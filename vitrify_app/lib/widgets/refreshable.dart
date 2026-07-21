// MainScreen'deki IndexedStack sekmeleri canlı tuttuğu için (initState bir
// daha çalışmaz) bu arayüzü uygulayan ekranlar, sekmeleri her seçildiğinde
// yeniden çağrılır — böylece başka bir sekmede değişen veriler (kredi,
// galeri) görünüme dönüldüğünde güncel gösterilir.
abstract class Refreshable {
  Future<void> refresh();
}
