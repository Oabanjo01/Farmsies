

enum Category {fruit, vegetable, fat, goat, sheep, livestock, poultry, fish, miscellanous, pig}

class Deals {
  final String title;
  final String description;
  final int price;
  final bool isCarted;
  final bool isFavourited;
  final int id;
  final String imagepath;
  final Category category;

  Deals({required this.category ,required this.id, required this.description, this.isCarted = false, this.isFavourited = false, required this.price, required this.title, required this.imagepath});
}

List <Deals> imageLink = [
  Deals(id: 1, description: 'Healthy white cockerels', price: 2000, title: 'Cockerels', category: Category.poultry, imagepath: 'https://images.unsplash.com/photo-1630090374791-c9eb7bab3935?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=872&q=80'), 
  Deals(id: 1, description: 'Healthy layers and point of lay.', price: 2000, title: 'Layers', category: Category.poultry, imagepath: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cG91bHRyeSUyMGZhcm18ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'), 
  Deals(category: Category.poultry, id: 3, description: 'Day old chicks for sale.', price: 400, title: 'Day old chicks', imagepath: 'https://images.unsplash.com/photo-1531155179084-3e1f15110922?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHBvdWx0cnklMjBmYXJtfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.livestock, id: 4, description: 'Healthy bulls for sale.', price: 700000, title: 'Bulls', imagepath: 'https://images.unsplash.com/photo-1517348249163-8a531dc68de7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fGFmcmljYW4lMjBmYXJtfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.fish, id: 5, description: 'Get the best fishes here!', price: 1500, title: 'Fish', imagepath: 'https://images.unsplash.com/photo-1607284956349-1bb094c2edfa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8ZmlzaCUyMG1hcmtldHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.miscellanous, id: 6, description: 'Get crop advice.', price: 10000, title: 'Crop advice', imagepath: 'https://media.istockphoto.com/photos/tracking-his-crops-with-technology-picture-id887287102?b=1&k=20&m=887287102&s=170667a&w=0&h=unEYk0MHNJ3guxE-sw5HlVVVnaJ49TciespunPxRorU='),
  Deals(category: Category.goat, id: 7, description: 'Get your plump goats for your celebrations!', price: 100000, title: 'Goats', imagepath: 'https://images.unsplash.com/photo-1593750439808-958d28558592?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Z29hdHN8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.fruit, id: 8, description: 'Strawberries in Nigeria not possible?\n I think not!', price: 500, title: 'Strawberries', imagepath: 'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGZydWl0c3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.fruit, id: 9, description: 'Neatly packaged fruit wih a free basket for you.', price: 5000, title: 'Fruit basket', imagepath: 'https://images.unsplash.com/photo-1519996529931-28324d5a630e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJ1aXRzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.poultry, id: 10, description: 'Fresh eggs, just for you.', price: 1500, title: 'Eggs', imagepath: 'https://images.unsplash.com/photo-1447624799968-c704f86dc931?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTJ8fGFmcmljYW4lMjBmYXJtfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.fruit, id: 11, description: 'Freshly plucked oranges for sale at affordable prices', price: 100, title: 'Oranges', imagepath: 'https://images.unsplash.com/photo-1557800636-894a64c1696f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGZydWl0c3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.fruit, id: 12, description: 'Varieties here', price: 1000, title: 'Fruits', imagepath: 'https://images.unsplash.com/photo-1618897996318-5a901fa6ca71?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8ZnJ1aXRzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.fish, id: 13, description: 'Crayfish in bulk and various sizes', price: 1000, title: 'Crayfish', imagepath: 'https://images.unsplash.com/photo-1580317092099-ade9937dee4f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8ZmlzaCUyMG1hcmtldHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.sheep, id: 14, description: 'Rams for your celebration', price: 400000, title: 'Ram', imagepath: 'https://images.unsplash.com/photo-1531914844844-01b1ccc3e609?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzF8fHNoZWVwJTIwd2l0aCUyMGhvcm5zfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.fruit, id: 15, description: 'Lemons for sale', price: 100, title: 'Lemens', imagepath: 'https://images.unsplash.com/photo-1534531173927-aeb928d54385?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fGZydWl0c3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.fruit, id: 16, description: 'Unboiled freshly caught crayfish', price: 2000, title: 'fresh Crayfish', imagepath: 'https://images.unsplash.com/photo-1504309250229-4f08315f3b5c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzZ8fGZpc2glMjBtYXJrZXR8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.pig, id: 17, description: 'Massive healthy pigs for sale', price: 200000, title: 'Pig', imagepath: 'https://images.unsplash.com/photo-1545468258-576dbac5faa9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cGlnJTIwZmFybXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.fish, id: 18, description: 'Bulk tuna\'s for sale', price: 1000, title: 'Tuna', imagepath: 'https://images.unsplash.com/photo-1601873631941-6cb104ad7dd5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fGZpc2glMjBtYXJrZXR8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.goat, id: 19, description: 'Male goats for sale', price: 100000, title: 'Goats', imagepath: 'https://images.unsplash.com/photo-1550348579-959785e820f7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8Z29hdHN8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.livestock, id: 20, description: 'Bulk cows for sale', price: 500000, title: 'Cattle', imagepath: 'https://images.unsplash.com/photo-1614005157364-67894d3dc531?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8Y2F0dGxlJTIwYWZyaWNhfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
  Deals(category: Category.pig, id: 21, description: 'Piglets for sale', price: 50000, title: 'Piglets', imagepath: 'https://images.unsplash.com/photo-1548781712-3da7f1a9dcd9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHBpZyUyMGZhcm18ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60')
];

