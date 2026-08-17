package com.microservices.ps.api.service;


import com.microservices.ps.api.entity.Payment;
import com.microservices.ps.api.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Random;
import java.util.UUID;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository repository;

    public Payment doPayment(Payment payment){
        payment.setTranscationId(UUID.randomUUID().toString());
        return repository.save(payment);
    }

}
