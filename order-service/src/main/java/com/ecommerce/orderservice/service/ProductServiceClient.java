package com.ecommerce.orderservice.service;

import com.ecommerce.orderservice.dto.ProductDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

@Service
public class ProductServiceClient {
    
    private final WebClient webClient;
    
    @Value("${services.product-service.url}")
    private String productServiceUrl;
    
    @Autowired
    public ProductServiceClient(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.build();
    }
    
    public ProductDTO getProduct(Long productId) {
        return webClient.get()
                .uri(productServiceUrl + "/api/products/" + productId)
                .retrieve()
                .bodyToMono(ProductDTO.class)
                .block();
    }
    
    public boolean checkStock(Long productId, Integer quantity) {
        try {
            String response = webClient.get()
                    .uri(productServiceUrl + "/api/products/" + productId + "/check-stock?quantity=" + quantity)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();
            return response != null && response.contains("\"available\":true");
        } catch (Exception e) {
            return false;
        }
    }
    
    public void updateStock(Long productId, Integer quantity) {
        webClient.patch()
                .uri(productServiceUrl + "/api/products/" + productId + "/stock")
                .bodyValue(new StockUpdate(quantity))
                .retrieve()
                .bodyToMono(Void.class)
                .block();
    }
    
    // Inner class for stock update request
    private static class StockUpdate {
        private Integer quantity;
        
        public StockUpdate(Integer quantity) {
            this.quantity = quantity;
        }
        
        public Integer getQuantity() {
            return quantity;
        }
        
        public void setQuantity(Integer quantity) {
            this.quantity = quantity;
        }
    }
}

