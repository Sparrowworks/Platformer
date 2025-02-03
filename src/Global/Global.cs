using Godot;
using System;

public partial class Global : Node
{
    public static Composer ComposerNode {get; private set;}

    public override void _Ready()
    {
        Composer ComposerNode = GetNode<Composer>("/root/Composer");
    }
}
