namespace Jalak{

  public class Bridge : GLib.Object {

    public void * context;

    public signal void test ();

    public Bridge(void * ctx){
      context = ctx;
    }
  }
}