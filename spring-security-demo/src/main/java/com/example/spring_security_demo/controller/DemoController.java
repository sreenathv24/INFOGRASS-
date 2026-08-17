package com.example.spring_security_demo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
public class DemoController {

    // ══════════════════════════════════════════════════════
    //  ✅ WITHOUT AUTHENTICATION — Public Endpoints
    //     Anyone can access — NO login required
    // ══════════════════════════════════════════════════════

    @GetMapping("/api/public/hello")
    public ResponseEntity<String> publicHello() {
        return ResponseEntity.ok("Hello! This is PUBLIC — No login needed!");
    }

    @GetMapping("/api/public/status")
    public ResponseEntity<String> publicStatus() {
        return ResponseEntity.ok("Service is UP and running!");
    }


    // ══════════════════════════════════════════════════════
    //  🔒 WITH AUTHENTICATION — USER Role
    //     Login required with ROLE_USER or ROLE_ADMIN
    // ══════════════════════════════════════════════════════

    @GetMapping("/api/user/dashboard")
    public ResponseEntity<String> userDashboard(Authentication auth) {
        return ResponseEntity.ok(
                "Welcome to USER Dashboard! \n" +
                        "Logged in as : " + auth.getName() + "\n" +
                        "Your Role    : " + auth.getAuthorities()
        );
    }

    @GetMapping("/api/user/profile")
    public ResponseEntity<String> userProfile(Authentication auth) {
        return ResponseEntity.ok(
                "User Profile: " + auth.getName()
        );
    }


    // ══════════════════════════════════════════════════════
    //  🔒 WITH AUTHENTICATION — ADMIN Role Only
    //     Login required with ROLE_ADMIN only
    // ══════════════════════════════════════════════════════

    @GetMapping("/api/admin/dashboard")
    public ResponseEntity<String> adminDashboard(Authentication auth) {
        return ResponseEntity.ok(
                "Welcome to ADMIN Dashboard! \n" +
                        "Admin User: " + auth.getName()
        );
    }

    @GetMapping("/api/admin/users")
    public ResponseEntity<String> getAllUsers(Authentication auth) {
        return ResponseEntity.ok(
                "Admin [" + auth.getName() + "] fetching all users!"
        );
    }

    @DeleteMapping("/api/admin/delete/{id}")
    public ResponseEntity<String> deleteUser(
            @PathVariable Long id, Authentication auth) {
        return ResponseEntity.ok(
                "User ID [" + id + "] deleted by admin: " + auth.getName()
        );
    }
}