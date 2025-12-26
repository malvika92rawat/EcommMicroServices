package com.ecommerce.apigateway.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class GatewayController {
    
    @GetMapping("/")
    public ResponseEntity<?> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("service", "API Gateway");
        response.put("status", "running");
        response.put("message", "Welcome to E-Commerce Microservices API Gateway");
        response.put("endpoints", Map.of(
            "auth", "/api/auth/**",
            "users", "/api/users/**",
            "products", "/api/products/**",
            "orders", "/api/orders/**"
        ));
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/health")
    public ResponseEntity<?> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "api-gateway");
        return ResponseEntity.ok(response);
    }
}

