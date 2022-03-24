package com.gerardnantel.pets;

import java.util.List;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class CatController {
    private final List<Cat> cats;

    public CatController() {
        cats = List.of(
            new Cat("Stark", 5),
            new Cat("Tyrion", 5),
            new Cat("Gilby", 9),
            new Cat("Slash", 12),
            new Cat("Tiki", 17),
            new Cat("Gracie", 18),
            new Cat("Minka", 15),
            new Cat("Minou", 14),
            new Cat("Lucipurr", 2),
            new Cat("Toby", 2)
        );
    }

    @GetMapping(path = "/cats", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Cat> getCats() {
        return cats;
    }
}