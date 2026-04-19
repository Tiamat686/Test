using Godot;
using System.Collections.Generic;

public partial class MagicProjectile : Projectile
{
    [Export] public float SplashRadius = 2.5f;
    [Export] public bool FriendlyFire = false;
    public string CasterFaction = "Neutral";

    public override void _PhysicsProcess(double delta)
    {
        if (Target == null || !GodotObject.IsInstanceValid(Target))
        {
            QueueFree();
            return;
        }

        Vector3 dir = Target.GlobalPosition - GlobalPosition;
        if (dir.Length() < 0.35f)
        {
            Explode();
            QueueFree();
            return;
        }

        GlobalPosition += dir.Normalized() * Speed * (float)delta;
    }

    private void Explode()
    {
        var scene = GetTree().CurrentScene;
        if (scene == null) return;

        foreach (Node child in scene.GetChildren())
        {
            ApplySplashRecursive(child);
        }
    }

    private void ApplySplashRecursive(Node node)
    {
        if (node is CombatUnit unit)
        {
            float dist = unit.GlobalPosition.DistanceTo(GlobalPosition);
            if (dist <= SplashRadius)
            {
                if (FriendlyFire || unit.Faction != CasterFaction)
                    unit.TakeDamage(Damage);
            }
        }

        foreach (Node child in node.GetChildren())
            ApplySplashRecursive(child);
    }
}
