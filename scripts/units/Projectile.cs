using Godot;

public partial class Projectile : Node3D
{
    [Export] public float Speed = 12f;
    public CombatUnit Target;
    public float Damage = 0f;
    public Color Tint = new Color(1, 1, 0.4f);

    public override void _Ready()
    {
        var mesh = GetNodeOrNull<MeshInstance3D>("MeshInstance3D");
        if (mesh != null)
            mesh.Modulate = Tint;
    }

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
            Target.TakeDamage(Damage);
            QueueFree();
            return;
        }

        GlobalPosition += dir.Normalized() * Speed * (float)delta;
    }
}
