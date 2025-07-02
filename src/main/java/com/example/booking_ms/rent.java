package com.example.booking_ms;



import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class rent {
    @GetMapping("/rent")
    public String getData() {return  "Please  pay rent Gaurav Bagate today itsel"  ; }
}
