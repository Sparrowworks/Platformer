using Godot;

public partial class Main : Control
{
    public override void _Ready()
    {
        Global.Composer.Call("load_scene", "res://src/MainMenu/MainMenu.tscn");
    }
}
