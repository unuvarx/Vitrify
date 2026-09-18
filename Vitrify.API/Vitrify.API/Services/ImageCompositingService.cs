using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Drawing.Processing;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;

namespace Vitrify.API.Services;

// Ürün kesimini (telefonda ML Kit ile arka planı kaldırılmış, şeffaf PNG)
// Gemini'nin ürettiği sahnenin üzerine yerleştirir. Gemini logoyu HİÇ
// görmediği için (sadece boş sahneyi üretiyor) marka/metin bozulma riski
// bu yolla ortadan kalkıyor — ürün pikselleri olduğu gibi kopyalanıyor.
public class ImageCompositingService
{
    public byte[] Composite(byte[] cutoutPngBytes, byte[] sceneBytes)
    {
        using var scene = Image.Load<Rgba32>(sceneBytes);
        using var cutout = Image.Load<Rgba32>(cutoutPngBytes);

        // Ürünü sahnenin yüksekliğinin ~%60'ına ölçekle, en-boy oranını koru
        var targetHeight = (int)(scene.Height * 0.6);
        var scale = (double)targetHeight / cutout.Height;
        var targetWidth = Math.Max(1, (int)(cutout.Width * scale));
        cutout.Mutate(x => x.Resize(targetWidth, targetHeight));

        // Ortala, dikeyde hafifçe merkezin altına koy (bir yüzeyde duruyormuş
        // hissi versin diye)
        var posX = (scene.Width - targetWidth) / 2;
        var posY = (int)((scene.Height - targetHeight) / 2 + scene.Height * 0.06);
        posY = Math.Clamp(posY, 0, Math.Max(0, scene.Height - targetHeight));

        // Ürünün altına yumuşak, oval bir gölge
        var shadowWidth = (int)(targetWidth * 0.75);
        var shadowHeight = Math.Max(8, (int)(targetHeight * 0.05));
        var shadowCenterX = posX + targetWidth / 2f;
        var shadowCenterY = posY + targetHeight - (shadowHeight / 2f);

        scene.Mutate(ctx =>
        {
            ctx.Fill(
                Color.FromRgba(0, 0, 0, 70),
                new SixLabors.ImageSharp.Drawing.EllipsePolygon(
                    shadowCenterX, shadowCenterY, shadowWidth / 2f, shadowHeight));

            var blurRegion = new Rectangle(
                Math.Max(0, (int)(shadowCenterX - shadowWidth)),
                Math.Max(0, (int)(shadowCenterY - shadowHeight * 2)),
                Math.Min(scene.Width, shadowWidth * 2),
                Math.Min(scene.Height, shadowHeight * 4));
            if (blurRegion.Width > 0 && blurRegion.Height > 0)
            {
                ctx.GaussianBlur(6f, blurRegion);
            }

            ctx.DrawImage(cutout, new Point(posX, posY), 1f);
        });

        using var ms = new MemoryStream();
        scene.Save(ms, new SixLabors.ImageSharp.Formats.Jpeg.JpegEncoder { Quality = 90 });
        return ms.ToArray();
    }
}
