package com.praneeth.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
@Slf4j
public class HelloWorldController {

    @GetMapping
public String helloWorld()
{
    log.info("hello world method started");
    return "hello world";
}
}
