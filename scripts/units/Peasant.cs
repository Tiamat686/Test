using Godot;

public partial class Peasant : CharacterBody3D
{
    [Export] public float Speed = 3.0f;

    private Vector3 _targetPosition;
    private bool _moving = false;

    private Node _goldMine;
    private Node _townHall;

    private int _carrying = 0;
    private int _capacity = 100;

    private float _gatherTimer = 0f;
    private float _gatherInterval = 1f;

    private enum State { Idle, MovingToMine, Gathering, Returning }
    private State _state = State.Idle;

    public void SetMine(Node mine) => _goldMine = mine;
    public void SetTownHall(Node hall) => _townHall = hall;

    public void MoveTo(Vector3 pos)
    {
        _targetPosition = pos;
        _moving = true;
        _state = State.Idle;
    }

    public void Gather()
    {
        if (_goldMine == null) return;
        _targetPosition = ((Node3D)_goldMine).GlobalPosition;
        _moving = true;
        _state = State.MovingToMine;
    }

    public void OnSelectionChanged(bool selected)
    {
        var sprite = GetNodeOrNull<Sprite3D>("Sprite3D");
        if (sprite != null)
            sprite.Modulate = selected ? new Color(0,1,0) : new Color(1,1,1);
    }

    public override void _PhysicsProcess(double delta)
    {
        switch (_state)
        {
            case State.MovingToMine:
                MoveStep();
                if (GlobalPosition.DistanceTo(((Node3D)_goldMine).GlobalPosition) < 1f)
                {
                    _state = State.Gathering;
                }
                break;

            case State.Gathering:
                _gatherTimer += (float)delta;
                if (_gatherTimer >= _gatherInterval)
                {
                    _gatherTimer = 0;
                    if (_carrying < _capacity)
                    {
                        var mined = (int)_goldMine.Call("harvest", 10);
                        _carrying += mined;
                    }
                    else
                    {
                        _targetPosition = ((Node3D)_townHall).GlobalPosition;
                        _moving = true;
                        _state = State.Returning;
                    }
                }
                break;

            case State.Returning:
                MoveStep();
                if (GlobalPosition.DistanceTo(((Node3D)_townHall).GlobalPosition) < 1f)
                {
                    _townHall.Call("deposit", _carrying);
                    _carrying = 0;
                    _state = State.Idle;
                }
                break;

            case State.Idle:
                if (_moving)
                    MoveStep();
                break;
        }
    }

    private void MoveStep()
    {
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
