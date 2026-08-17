package com.example.spring_security_demo.service;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    // ─────────────────────────────────────────────────────
    // 🗃️ In-Memory Users
    //    username  →  [ BCryptPassword,  Role      ]
    //    password for both users is:  "password"
    // ─────────────────────────────────────────────────────
    private static final Map<String, String[]> USERS = new HashMap<>();

    static {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String encodedPassword = encoder.encode("password");

        USERS.put("user",  new String[]{ encodedPassword, "ROLE_USER"  });
        USERS.put("admin", new String[]{ encodedPassword, "ROLE_ADMIN" });
    }

    @Override
    public UserDetails loadUserByUsername(String username)
            throws UsernameNotFoundException {

        // ── Real DB approach (use this when JPA is added) ──────────
        // UserEntity user = userRepository.findByUsername(username)
        //     .orElseThrow(() ->
        //         new UsernameNotFoundException("User not found: " + username));
        // return User.builder()
        //     .username(user.getUsername())
        //     .password(user.getPassword())
        //     .authorities(user.getRole())
        //     .build();
        // ───────────────────────────────────────────────────────────

        // ── In-Memory approach ──────────────────────────────────────
        if (!USERS.containsKey(username)) {
            throw new UsernameNotFoundException("User not found: " + username);
        }

        String[] data = USERS.get(username);

        return User.builder()
                .username(username)
                .password(data[0])        // BCrypt encoded password
                .authorities(data[1])     // ROLE_USER or ROLE_ADMIN
                .build();
    }
}