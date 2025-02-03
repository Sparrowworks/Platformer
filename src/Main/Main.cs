using Godot;
using System;

public partial class Main : Control
{
    public override void _Ready()
    {
        Composer Composer = GetNode<Composer>("/root/Composer");
        Composer.Root = this;
        Composer.LoadScene("res://src/MainMenu/MainMenu.tscn");
    }
}
