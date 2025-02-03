using Godot;

public partial class Global : Node
{
    public static Node Composer;
    public override void _Ready()
    {
        Composer = GetNode<Node>("/root/Composer");
    }
}
