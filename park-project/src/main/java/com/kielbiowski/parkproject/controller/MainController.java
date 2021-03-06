package com.kielbiowski.parkproject.controller;

import com.kielbiowski.parkproject.dto.UserDTO;
import com.kielbiowski.parkproject.service.model.UserService;
import com.kielbiowski.parkproject.service.security.SecurityService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MainController {

    private final UserService userService;
    private final SecurityService securityService;

    public MainController(UserService userService, SecurityService securityService) {
        this.userService = userService;
        this.securityService = securityService;
    }

    @GetMapping(path = {"/index", "/", ""})
    public String indexGet(Model model) {
        UserDTO userDTO = null;
        String email = securityService.findLoggedInUsername();
        if (email != null) {
            userDTO = userService.findByEmail(email);
        }
        model.addAttribute("userDTO", userDTO);
        return "index";
    }

}
