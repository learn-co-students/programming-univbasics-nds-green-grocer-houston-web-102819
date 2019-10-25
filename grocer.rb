def find_item_by_name_in_collection(name, collection)
  i = 0
  while i < collection.length do
    return collection[i] if name === collection[i][:item]
    i += 1
  end
  nil
end

def consolidate_cart(cart)
  new_cart = []
  i = 0
  while i < cart.length do
    item = cart[i][:item]
    search = find_item_by_name_in_collection(item, new_cart)
    if search
      search[:count] += 1
    else
      cart[i][:count] = 1
      new_cart << cart[i]
    end
    i += 1
  end
  new_cart
end

def make_coupon_hash(coup)
  rounded_price = (coup[:cost].to_f * 1.0/ coup[:num]).round(2)
  {
    :item => "#{coup[:item]} W/COUPON",
    :price => rounded_price,
    :count => coup[:num]
  }
end

def apply_coupon_to_cart(matching_item, coupon, cart)
  matching_item[:count] -= coupon[:num]
  item_with_coupon = make_coupon_hash(coupon)
  item_with_coupon[:clearance] = matching_item[:clearance]
  cart << item_with_coupon
end

def apply_coupons(cart, coupons)
  i = 0
  while i < coupons.count do
    coupon = coupons[i]
    item_with_coupon = find_item_by_name_in_collection(coupon[:item], cart)
    item_is_in_basket = !!item_with_coupon
    count_is_big_enough_to_apply = item_is_in_basket && item_with_coupon[:count] >= coupon[:num]

    if item_is_in_basket and count_is_big_enough_to_apply
      apply_coupon_to_cart(item_with_coupon, coupon, cart)
    end
    i += 1
  end
  cart
end

def apply_clearance(cart)
  i = 0
  while i < cart.length do
    item = cart[i]
    if item[:clearance]
      clearance_price = (item[:price] * 0.8).round(2)
      item[:price] = clearance_price
    end
    i += 1 
  end
  cart
end

def all_item_cost(i)
  i[:price] * i[:count]
end
  
def checkout(cart, coupons)
  con_cart = consolidate_cart(cart)
  apply_coupons(con_cart, coupons)
  apply_clearance(con_cart)
  
  i = 0 
  total = 0 
  
  while i < con_cart.length do
    total += all_item_cost(con_cart[i])
    i += 1 
  end
  total >= 100 ? (total * 0.9).round(2) : total
end
