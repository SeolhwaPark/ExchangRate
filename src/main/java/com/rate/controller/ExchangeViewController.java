package com.rate.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
@RequestMapping("/ExchangeView")
public class ExchangeViewController {

	@GetMapping("currencies_view")
	public void currencies_view() {
		
	}
	
	@GetMapping("rate_chart")
	public void rate_chart(Model model, @RequestParam("currencies") List<String> currency)
	{
		String str = "";
		
		for (int i = 0; i < currency.size(); ++i)
			str += currency.get(i) + (i + 1 >= currency.size() ? "" : ",");
		
		model.addAttribute("params", str);
	}
	

	@GetMapping("real_time")
	public void real_time() {
		
	}
}
