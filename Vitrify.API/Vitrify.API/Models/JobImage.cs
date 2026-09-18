namespace Vitrify.API.Models;

// Bir Job'a yüklenen kaynak görsellerin base64 verisi — JobItem başına değil,
// Job başına BİR KEZ saklanır (senaryo sayısı kadar tekrarlanmaz). JobItem'lar
// buraya Index üzerinden referans verir.
public class JobImage
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid JobId { get; set; }
    public Job? Job { get; set; }

    // Bu Job içindeki sırası (0, 1, 2, ...) — JobItem.ImageIndex bununla eşleşir
    public int Index { get; set; }

    // Saf base64 (data: öneki olmadan, Gemini'ye gönderilir)
    public string Base64Data { get; set; } = string.Empty;

    // true: bu, telefonda ML Kit ile arka planı kaldırılmış (şeffaf PNG)
    // bir ürün kesimi — bu durumda Gemini'ye ürünü hiç göstermeden sadece
    // sahneyi ürettirip kesimi üzerine biz yapıştırıyoruz (logo/marka
    // bozulmasını önlemek için, bkz. JobProcessingService).
    // false: eski akış — orijinal fotoğraf olduğu gibi Gemini'ye gönderilir
    // (cihaz kesim özelliğini desteklemiyorsa/başarısız olduysa fallback).
    public bool IsCutout { get; set; }
}
