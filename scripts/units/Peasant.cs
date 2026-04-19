using Godot;

public partial class Peasant : CharacterBody3D
{
    [Export] public float Speed = 3.0f;
    private Vector3 _targetPosition;
    private bool _moving = false;

    public void MoveTo(Vector3 pos)
    {
        _targetPosition = pos;
        _moving = true;
    }

    public override void _PhysicsProcess(double delta)
    {
        if (!_moving) return;

        Vector3 dir = (_targetPosition - GlobalPosition).Normalized();
        Velocity = dir * Speed;
        MoveAndSlide();

        if (GlobalPosition.DistanceTo(_targetPosition) < 0.5f)
        {
            _moving = false;
            Velocity = Vector3.Zero;
        }
    }
}
