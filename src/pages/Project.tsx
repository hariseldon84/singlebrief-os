import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import { ArrowLeft, Sparkles, Loader2, FileText, CheckCircle2, Circle } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";

interface Project {
  id: string;
  name: string;
  description: string | null;
}

interface Brief {
  id: string;
  content: string;
  status: string;
  created_at: string;
}

interface Task {
  id: string;
  title: string;
  description: string | null;
  type: "ai" | "human";
  status: "pending" | "in_progress" | "completed";
  assigned_to: string | null;
}

const Project = () => {
  const { id } = useParams<{ id: string }>();
  const [project, setProject] = useState<Project | null>(null);
  const [briefs, setBriefs] = useState<Brief[]>([]);
  const [tasks, setTasks] = useState<Task[]>([]);
  const [newBrief, setNewBrief] = useState("");
  const [isGenerating, setIsGenerating] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const navigate = useNavigate();
  const { toast } = useToast();

  useEffect(() => {
    const checkAuth = async () => {
      const { data: { session } } = await supabase.auth.getSession();
      if (!session) {
        navigate("/auth");
        return;
      }
      loadProject();
    };

    checkAuth();
  }, [id, navigate]);

  const loadProject = async () => {
    try {
      const { data: projectData, error: projectError } = await supabase
        .from("projects")
        .select("*")
        .eq("id", id)
        .single();

      if (projectError) throw projectError;
      setProject(projectData);

      const { data: briefsData, error: briefsError } = await supabase
        .from("briefs")
        .select("*")
        .eq("project_id", id)
        .order("created_at", { ascending: false });

      if (briefsError) throw briefsError;
      setBriefs(briefsData || []);

      if (briefsData && briefsData.length > 0) {
        const { data: tasksData, error: tasksError } = await supabase
          .from("tasks")
          .select(`
            *,
            assigned_profile:profiles!tasks_assigned_to_fkey(name)
          `)
          .in("brief_id", briefsData.map((b) => b.id))
          .order("created_at", { ascending: false });

        if (tasksError) throw tasksError;
        setTasks(tasksData || []);
      }
    } catch (error: any) {
      toast({
        title: "Error",
        description: error.message,
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleGenerateTasks = async () => {
    if (!newBrief.trim()) return;

    setIsGenerating(true);

    try {
      const { data: { session } } = await supabase.auth.getSession();
      
      const { data: briefData, error: briefError } = await supabase
        .from("briefs")
        .insert([{
          project_id: id,
          content: newBrief,
          status: "generating",
          created_by: session?.user?.id
        }])
        .select()
        .single();

      if (briefError) throw briefError;

      const { data: tasksData, error: functionError } = await supabase.functions.invoke(
        "generate-tasks",
        {
          body: { brief: newBrief, briefId: briefData.id }
        }
      );

      if (functionError) throw functionError;

      await supabase
        .from("briefs")
        .update({ status: "active" })
        .eq("id", briefData.id);

      toast({
        title: "Tasks generated!",
        description: `Created ${tasksData.tasks.length} tasks from your brief`,
      });

      setNewBrief("");
      loadProject();
    } catch (error: any) {
      toast({
        title: "Error",
        description: error.message,
        variant: "destructive",
      });
    } finally {
      setIsGenerating(false);
    }
  };

  const handleTaskStatusChange = async (taskId: string, newStatus: "pending" | "in_progress" | "completed") => {
    try {
      const { error } = await supabase
        .from("tasks")
        .update({ status: newStatus })
        .eq("id", taskId);

      if (error) throw error;

      loadProject();
      
      toast({
        title: "Status updated",
        description: "Task status has been updated",
      });
    } catch (error: any) {
      toast({
        title: "Error",
        description: error.message,
        variant: "destructive",
      });
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-subtle flex items-center justify-center">
        <Sparkles className="h-12 w-12 text-primary animate-pulse" />
      </div>
    );
  }

  if (!project) return null;

  const completedTasks = tasks.filter(t => t.status === "completed").length;
  const progress = tasks.length > 0 ? (completedTasks / tasks.length) * 100 : 0;

  return (
    <div className="min-h-screen bg-gradient-subtle">
      <header className="border-b bg-card/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="container mx-auto px-4 py-4">
          <Button variant="ghost" size="sm" onClick={() => navigate("/dashboard")} className="mb-2">
            <ArrowLeft className="h-4 w-4 mr-2" />
            Back to Dashboard
          </Button>
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold">{project.name}</h1>
              {project.description && (
                <p className="text-muted-foreground mt-1">{project.description}</p>
              )}
            </div>
            <div className="text-right">
              <div className="text-sm text-muted-foreground mb-1">Progress</div>
              <div className="flex items-center gap-2">
                <Progress value={progress} className="w-32" />
                <span className="text-sm font-medium">{Math.round(progress)}%</span>
              </div>
            </div>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        <div className="grid gap-8 lg:grid-cols-2">
          <div>
            <Card className="shadow-elegant border-0 bg-gradient-card backdrop-blur-sm">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Sparkles className="h-5 w-5 text-primary" />
                  Create Brief
                </CardTitle>
                <CardDescription>
                  Describe your project needs and let AI generate tasks
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <Textarea
                  placeholder="Describe what you need to accomplish... For example: 'Create a marketing campaign for our new product launch including social media posts, email templates, and landing page copy'"
                  value={newBrief}
                  onChange={(e) => setNewBrief(e.target.value)}
                  rows={6}
                  className="resize-none"
                />
                <Button
                  onClick={handleGenerateTasks}
                  disabled={isGenerating || !newBrief.trim()}
                  className="w-full"
                >
                  {isGenerating ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Generating tasks...
                    </>
                  ) : (
                    <>
                      <Sparkles className="mr-2 h-4 w-4" />
                      Generate Tasks with AI
                    </>
                  )}
                </Button>
              </CardContent>
            </Card>

            <Card className="shadow-elegant border-0 bg-gradient-card backdrop-blur-sm mt-6">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="h-5 w-5" />
                  Recent Briefs
                </CardTitle>
              </CardHeader>
              <CardContent>
                {briefs.length === 0 ? (
                  <p className="text-sm text-muted-foreground">No briefs yet</p>
                ) : (
                  <div className="space-y-3">
                    {briefs.slice(0, 3).map((brief) => (
                      <div key={brief.id} className="p-3 rounded-lg bg-muted/50">
                        <p className="text-sm line-clamp-2">{brief.content}</p>
                        <div className="flex items-center gap-2 mt-2">
                          <Badge variant={brief.status === "active" ? "default" : "secondary"}>
                            {brief.status}
                          </Badge>
                          <span className="text-xs text-muted-foreground">
                            {new Date(brief.created_at).toLocaleDateString()}
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          </div>

          <div>
            <Card className="shadow-elegant border-0 bg-gradient-card backdrop-blur-sm">
              <CardHeader>
                <CardTitle>Tasks</CardTitle>
                <CardDescription>
                  {tasks.length} {tasks.length === 1 ? "task" : "tasks"} • {completedTasks} completed
                </CardDescription>
              </CardHeader>
              <CardContent>
                {tasks.length === 0 ? (
                  <div className="text-center py-8">
                    <CheckCircle2 className="h-12 w-12 text-muted-foreground mx-auto mb-2" />
                    <p className="text-sm text-muted-foreground">
                      No tasks yet. Create a brief to generate tasks.
                    </p>
                  </div>
                ) : (
                  <div className="space-y-3">
                    {tasks.map((task) => (
                      <div
                        key={task.id}
                        className="p-4 rounded-lg border bg-card hover:shadow-md transition-shadow"
                      >
                        <div className="flex items-start justify-between gap-3">
                          <div className="flex-1">
                            <div className="flex items-center gap-2 mb-2">
                              <h4 className="font-semibold">{task.title}</h4>
                              <Badge variant={task.type === "ai" ? "default" : "secondary"}>
                                {task.type}
                              </Badge>
                            </div>
                            {task.description && (
                              <p className="text-sm text-muted-foreground mb-2">
                                {task.description}
                              </p>
                            )}
                          </div>
                          <Button
                            size="sm"
                            variant={task.status === "completed" ? "default" : "outline"}
                            onClick={() => {
                              const nextStatus = 
                                task.status === "pending" ? "in_progress" :
                                task.status === "in_progress" ? "completed" : "pending";
                              handleTaskStatusChange(task.id, nextStatus);
                            }}
                          >
                            {task.status === "completed" ? (
                              <CheckCircle2 className="h-4 w-4" />
                            ) : (
                              <Circle className="h-4 w-4" />
                            )}
                          </Button>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Project;