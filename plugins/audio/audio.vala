/*
 * jalak - plugin app poc
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */

public class Core : Peas.ExtensionBase, Jalak.Plugin{

    private Jalak.Bridge bridge;
    private AudioGlue glue;

    public void init(void * ctx){
        bridge = (Jalak.Bridge) ctx;
        
        glue = new AudioGlue(this);
        glue.start();

        Jalak.Util.inject_plugin_script(bridge.page, get_plugin_info());
    }

    public void destroy(){
        glue.destroy();
        stdout.printf("core destroy \n");
    }
        
    public void update(string data){
        Jalak.Util.inject_script(bridge.page, "Jalak.plugins[\"audio\"]().update(" + data + ")");
    }

    public void draw(string data){
        stdout.printf("core destroy \n");
    }

    public bool exec(string data){
        glue.sync_volume(int.parse(data));
        return false;
    }

    public string get_info(){
        // TODO: serialized audio_status and info about the plugin
        return "{ \"volume\" : 24 }";
    }
 }

[ModuleInit]
public void peas_register_types(GLib.TypeModule module)
{
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type(typeof (Jalak.Plugin), typeof (Core));
}