namespace Jalak{

  public class Bridge : GLib.Object {

    public void * context;
    public Jalak.Page page;

    public signal void test ();

    public Bridge(void * ctx, Jalak.Page p){
      context = ctx;
      page = p;
    }
  }
}