package com.ecommerce.apigateway.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/fallback")
public class FallbackController {
    
    @GetMapping("/user-service")
    public ResponseEntity<?> userServiceFallback() {
        Map<String, String> response = new HashMap<>();
        response.put("error", "User Service is currently unavailable. Please try again later.");
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
    
    @GetMapping("/product-service")
    public ResponseEntity<?> productServiceFallback() {
        Map<String, String> response = new HashMap<>();
        response.put("error", "Product Service is currently unavailable. Please try again later.");
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
    
    @GetMapping("/order-service")
    public ResponseEntity<?> orderServiceFallback() {
        Map<String, String> response = new HashMap<>();
        response.put("error", "Order Service is currently unavailable. Please try again later.");
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
}

