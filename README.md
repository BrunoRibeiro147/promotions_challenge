# HorizonChallenge

Resolution of the [challenge](https://gist.github.com/noverloop/86c4993b16f589637d06e66a04f4a6c2), the ideia is be able to receive an array of products codes and be able to apply promotion on them

## Installation

  * Clone the project
  * Run `mix setup` its gonna download the dependencies, create, migrate and run the seeds on the database
  * Start Phoenix application using `iex -S mix phx.server`
  
## Usage
   
   * You can use the simple interface to scan items: 
   
   ```elixir
   # pricing_rules = Array of codes of the existents promotions
   
   pricing_rules = ["2-for-1"]
   
   co = HorizonChallenge.Checkout.new(pricing_rules)
   
   co.scan("VOUCHER")
   co.scan("VOUCHER")
   co.scan("TSHIRT")
   
   co.total
   
   # €25.00
   ```
 
  * For create a new product you can use the services:
  
  ```elixir
   params = %{name: "Macbook Air", code: "MAC", price: 1000000}
  
   # When working with money we use integer to avoid problems with floats imprecisions
   # 1000000 = 10000.00
  
   HorizonChallenge.Products.Services.CreateProduct.execute(params)
  ```
  
  * For update the price of a product:
  
  ```elixir
   params = %{product_id: 1, price: 1200000}
    
   HorizonChallenge.Products.Services.UpdateProductPrice.execute(params)
  ```
  
  * For create a new promotion
  
  ```elixir    
   params = %{
        name: "Buy 2 itens and gain 1 for free",
        code: "2-for-1",
        amount_for_enable_promotion: 2,
        discount_percentage: 100,
        products_affected_by_promotion: "1"
      } 
    
   # name: Name of promotion
   # code: Code of promotion, used for apply promotion
   # amount_for_enable_promotion: quantity of products necessary for the promotion be valid
   # discount_percentage: how much discount this promotions gives
   # products_affected_by_promotion: Quantity of products the promotions will be applied, in case of all products receive the discount use `all`
    
   HorizonChallenge.Promotions.Services.CreatePromotion.execute(params)
  ```
  
  * For add a new product to the promotion
  
  ```elixir 
  params = %{promotion_id: 1, product_id: 1} 
  
  HorizonChallenge.Promotions.Services.UpdateProductOnPromotion.execute(params)
  ```
  
  
  

