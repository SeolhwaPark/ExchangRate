package com.rate.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/ExchangeRate")
@Log4j
public class ExchangeRateController {
//https://creativeegg.duckdns.org:54321/api/exchange/rate?currency=jpy
	// private ExchangeRateService service;
	@GetMapping(value = "/currencies", produces = "application/json; charset=UTF-8")
	public String rate_currencies() {
		log.info("*******rate_view()*******");

		String result = null;
		try {
			CloseableHttpClient httpclient = HttpClients.createDefault();
			HttpGet httpGet = new HttpGet("https://creativeegg.duckdns.org:54321/api/exchange/currencies");
			CloseableHttpResponse response = httpclient.execute(httpGet);

			try {
				result = EntityUtils.toString(response.getEntity());

			} finally {
				response.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;

	}

	@GetMapping(value="/rate", produces = "application/json; charset=UTF-8")
	public String rate(@RequestParam("currency") String currency ) throws Exception 
	{
		String[] 				currencies;
		ArrayList<String> 		list = new ArrayList<String>();
		CloseableHttpResponse 	response;
		CloseableHttpClient	 	httpclient = HttpClients.createDefault();

		currencies = currency.split(",");
		        
		if (currencies == null)
		{		        
			response = httpclient.execute(new HttpGet("https://creativeegg.duckdns.org:54321/api/exchange/rate?currency=" + currency));
			list.add(EntityUtils.toString(response.getEntity()));
			response.close();
		}
		else
		{
			for (int i = 0; i < currencies.length; ++i)
			{
				response = httpclient.execute(new HttpGet("https://creativeegg.duckdns.org:54321/api/exchange/rate?currency=" + currencies[i]));
				list.add(EntityUtils.toString(response.getEntity()));
				response.close();
			}
		}
		
		return list.toString();
	}
	
	@GetMapping(value="/time", produces = "application/json; charset=UTF-8")
	public Map time() throws Exception 
	{
		Map<String, String> map = new HashMap<String, String>();
		
		ArrayList<Map<String, String>> list = new ArrayList();
		
		map.put("currency", "JPY");
		map.put("currency", "USD");
		map.put("currency", "PHP");
		map.put("currency", "CNY");
		map.put("currency", "EUD");
	
		return map;
	}
	
	@GetMapping(value="/real_time", produces = "application/json; charset=UTF-8")
	public String rate_time(@RequestParam("currency") String currency ) throws Exception 
	{
		String[] 				currencies;
		ArrayList<String> 		list = new ArrayList<String>();
		CloseableHttpResponse 	response;
		CloseableHttpClient	 	httpclient = HttpClients.createDefault();

		currencies = currency.split(",");
		        
		if (currencies == null)
		{		        
			response = httpclient.execute(new HttpGet("https://creativeegg.duckdns.org:54321/api/exchange/rate?currency=" + currency));
			list.add(EntityUtils.toString(response.getEntity()));
			response.close();
		}
		else
		{
			for (int i = 0; i < currencies.length; ++i)
			{
				response = httpclient.execute(new HttpGet("https://creativeegg.duckdns.org:54321/api/exchange/rate?currency=" + currencies[i]));
				list.add(EntityUtils.toString(response.getEntity()));
				response.close();
			}
		}
		
		return list.toString();
	}
}