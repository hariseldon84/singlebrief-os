import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Sparkles, Zap, Users, BarChart3, ArrowRight } from "lucide-react";

const Index = () => {
  const navigate = useNavigate();

  useEffect(() => {
    const checkAuth = async () => {
      const { supabase } = await import("@/integrations/supabase/client");
      const { data: { session } } = await supabase.auth.getSession();
      if (session) {
        navigate("/dashboard");
      }
    };
    checkAuth();
  }, [navigate]);

  return (
    <div className="min-h-screen bg-gradient-subtle">
      <nav className="border-b bg-card/50 backdrop-blur-sm">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Sparkles className="h-6 w-6 text-primary" />
            <span className="text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent">
              SingleBrief
            </span>
          </div>
          <Button onClick={() => navigate("/auth")}>
            Get Started
            <ArrowRight className="ml-2 h-4 w-4" />
          </Button>
        </div>
      </nav>

      <main>
        <section className="container mx-auto px-4 py-20 text-center">
          <div className="max-w-4xl mx-auto">
            <div className="inline-flex items-center gap-2 bg-primary/10 text-primary px-4 py-2 rounded-full mb-6">
              <Sparkles className="h-4 w-4" />
              <span className="text-sm font-medium">AI-Powered Project Management</span>
            </div>
            
            <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-gradient-primary bg-clip-text text-transparent">
              Brief-First Project OS
            </h1>
            
            <p className="text-xl text-muted-foreground mb-8 max-w-2xl mx-auto">
              Transform your project briefs into actionable tasks instantly. 
              Let AI intelligently break down complex projects while you focus on execution.
            </p>

            <div className="flex gap-4 justify-center mb-16">
              <Button size="lg" onClick={() => navigate("/auth")} className="gap-2">
                <Sparkles className="h-5 w-5" />
                Start Free Trial
              </Button>
              <Button size="lg" variant="outline" onClick={() => navigate("/auth")}>
                View Demo
              </Button>
            </div>

            <div className="grid md:grid-cols-3 gap-8 mt-20">
              <div className="p-6 rounded-lg bg-gradient-card backdrop-blur-sm shadow-elegant">
                <div className="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center mb-4 mx-auto">
                  <Zap className="h-6 w-6 text-primary" />
                </div>
                <h3 className="text-xl font-semibold mb-2">AI Task Generation</h3>
                <p className="text-muted-foreground">
                  Automatically break down briefs into micro-tasks with intelligent AI classification
                </p>
              </div>

              <div className="p-6 rounded-lg bg-gradient-card backdrop-blur-sm shadow-elegant">
                <div className="h-12 w-12 rounded-lg bg-secondary/10 flex items-center justify-center mb-4 mx-auto">
                  <Users className="h-6 w-6 text-secondary" />
                </div>
                <h3 className="text-xl font-semibold mb-2">Team Collaboration</h3>
                <p className="text-muted-foreground">
                  Assign tasks to team members and track progress across departments
                </p>
              </div>

              <div className="p-6 rounded-lg bg-gradient-card backdrop-blur-sm shadow-elegant">
                <div className="h-12 w-12 rounded-lg bg-success/10 flex items-center justify-center mb-4 mx-auto">
                  <BarChart3 className="h-6 w-6 text-success" />
                </div>
                <h3 className="text-xl font-semibold mb-2">Progress Tracking</h3>
                <p className="text-muted-foreground">
                  Real-time project insights with automated status updates and analytics
                </p>
              </div>
            </div>
          </div>
        </section>

        <section className="container mx-auto px-4 py-20">
          <div className="max-w-4xl mx-auto bg-gradient-primary p-12 rounded-2xl text-center shadow-elegant">
            <h2 className="text-4xl font-bold text-white mb-4">
              Ready to transform your workflow?
            </h2>
            <p className="text-white/90 mb-8 text-lg">
              Join teams already using SingleBrief to streamline their project management
            </p>
            <Button size="lg" variant="secondary" onClick={() => navigate("/auth")} className="gap-2">
              Get Started Free
              <ArrowRight className="h-5 w-5" />
            </Button>
          </div>
        </section>
      </main>

      <footer className="border-t bg-card/50 backdrop-blur-sm py-8">
        <div className="container mx-auto px-4 text-center text-sm text-muted-foreground">
          <p>© 2025 SingleBrief. All rights reserved.</p>
        </div>
      </footer>
    </div>
  );
};

export default Index;