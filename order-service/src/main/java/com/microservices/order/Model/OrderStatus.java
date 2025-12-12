package com.microservices.order.Model;

/**
 * Order Status Enum
 * Sipariş durumlarını temsil eder
 * 
 * Enum kullanmanın faydaları:
 * 1. Type Safety: Compile-time'da hata yakalama
 * 2. Magic String'lerden kaçınma: "PENDING" yerine OrderStatus.PENDING
 * 3. IDE desteği: Autocomplete, refactoring kolaylığı
 * 4. Kod okunabilirliği: Daha anlaşılır kod
 * 5. Değer kontrolü: Sadece belirli değerler kullanılabilir
 */
public enum OrderStatus {
    
    /**
     * Beklemede
     * Sipariş oluşturuldu, henüz onaylanmadı
     * Stok kontrolü yapılmalı
     */
    PENDING("Beklemede"),
    
    /**
     * Onaylandı
     * Stok kontrolü yapıldı, sipariş onaylandı
     * Ödeme bekleniyor veya yapıldı
     */
    CONFIRMED("Onaylandı"),

    /**
     * Ödeme bekleniyor
     * Ödeme sağlayıcısı yanıtı gelmedi/işleniyor
     */
    PAYMENT_PENDING("Ödeme bekleniyor"),

    /**
     * Ödeme başarısız
     * Stok rezervi varsa geri bırakılmalı
     */
    PAYMENT_FAILED("Ödeme başarısız"),
    
    /**
     * İşleniyor
     * Sipariş hazırlanıyor, paketleniyor
     */
    PROCESSING("İşleniyor"),
    
    /**
     * Kargoya verildi
     * Sipariş kargo firmasına teslim edildi
     * Kargo takip numarası atanmalı
     */
    SHIPPED("Kargoya verildi"),
    
    /**
     * Teslim edildi
     * Sipariş müşteriye ulaştı
     */
    DELIVERED("Teslim edildi"),

    /**
     * İade/geri ödeme talep edildi
     */
    REFUND_REQUESTED("İade talep edildi"),

    /**
     * İade/geri ödeme tamamlandı
     */
    REFUNDED("İade tamamlandı"),
    
    /**
     * İptal edildi
     * Sipariş iptal edildi
     * Stok geri verilmeli
     */
    CANCELLED("İptal edildi");
    
    private final String description;
    
    OrderStatus(String description) {
        this.description = description;
    }
    
    public String getDescription() {
        return description;
    }
}

