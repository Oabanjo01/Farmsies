import '../Models/item-model.dart';
import '../Models/tips-model.dart';



// List<ItemModel> imageLink = [
//   ItemModel(
//       id: 3,
//       description: 'Day old chicks for sale.',
//       price: 400,
//       title: 'Day old chicks',
//       imagepath:
//           'https://images.unsplash.com/photo-1531155179084-3e1f15110922?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHBvdWx0cnklMjBmYXJtfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
//       id: 4,
//       description: 'Healthy bulls for sale.',
//       price: 700000,
//       title: 'Bulls',
//       imagepath:
//           'https://images.unsplash.com/photo-1517348249163-8a531dc68de7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fGFmcmljYW4lMjBmYXJtfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
//             id: 5,
//       description: 'Get the best fishes here!',
//       price: 1500,
//       title: 'Fish',
//       imagepath:
//           'https://images.unsplash.com/photo-1607284956349-1bb094c2edfa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8ZmlzaCUyMG1hcmtldHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
//       id: 6,
//       description: 'Get crop advice.',
//       price: 10000,
//       title: 'Crop advice',
//       imagepath:
//           'https://media.istockphoto.com/photos/tracking-his-crops-with-technology-picture-id887287102?b=1&k=20&m=887287102&s=170667a&w=0&h=unEYk0MHNJ3guxE-sw5HlVVVnaJ49TciespunPxRorU='),
//   ItemModel(
//             id: 7,
//       description: 'Get your plump goats for your celebrations!',
//       price: 100000,
//       title: 'Goats',
//       imagepath:
//           'https://images.unsplash.com/photo-1593750439808-958d28558592?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Z29hdHN8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
      
//       id: 8,
//       description: 'Strawberries in Nigeria not possible?\n I think not!',
//       price: 500,
//       title: 'Strawberries',
//       imagepath:
//           'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGZydWl0c3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
      
//       id: 9,
//       description: 'Neatly packaged fruit wih a free basket for you.',
//       price: 5000,
//       title: 'Fruit basket',
//       imagepath:
//           'https://images.unsplash.com/photo-1519996529931-28324d5a630e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJ1aXRzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
      
//       id: 10,
//       description: 'Fresh eggs, just for you.',
//       price: 1500,
//       title: 'Eggs',
//       imagepath:
//           'https://images.unsplash.com/photo-1447624799968-c704f86dc931?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTJ8fGFmcmljYW4lMjBmYXJtfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
      
//       id: 11,
//       description: 'Freshly plucked oranges for sale at affordable prices',
//       price: 100,
//       title: 'Oranges',
//       imagepath:
//           'https://images.unsplash.com/photo-1557800636-894a64c1696f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGZydWl0c3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
      
//       id: 12,
//       description: 'Varieties here',
//       price: 1000,
//       title: 'Fruits',
//       imagepath:
//           'https://images.unsplash.com/photo-1618897996318-5a901fa6ca71?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8ZnJ1aXRzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
      
//       id: 13,
//       description: 'Crayfish in bulk and various sizes',
//       price: 1000,
//       title: 'Crayfish',
//       imagepath:
//           'https://images.unsplash.com/photo-1580317092099-ade9937dee4f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8ZmlzaCUyMG1hcmtldHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
      
//       id: 14,
//       description: 'Rams for your celebration',
//       price: 400000,
//       title: 'Ram',
//       imagepath:
//           'https://images.unsplash.com/photo-1531914844844-01b1ccc3e609?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzF8fHNoZWVwJTIwd2l0aCUyMGhvcm5zfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
      
//       id: 15,
//       description: 'Lemons for sale',
//       price: 100,
//       title: 'Lemens',
//       imagepath:
//           'https://images.unsplash.com/photo-1534531173927-aeb928d54385?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fGZydWl0c3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
      
//       id: 16,
//       description: 'Unboiled freshly caught crayfish',
//       price: 2000,
//       title: 'fresh Crayfish',
//       imagepath:
//           'https://images.unsplash.com/photo-1504309250229-4f08315f3b5c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzZ8fGZpc2glMjBtYXJrZXR8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
//             id: 18,
//       description: 'Bulk tuna\'s for sale',
//       price: 1000,
//       title: 'Tuna',
//       imagepath:
//           'https://images.unsplash.com/photo-1601873631941-6cb104ad7dd5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fGZpc2glMjBtYXJrZXR8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
//             id: 19,
//       description: 'Male goats for sale',
//       price: 100000,
//       title: 'Goats',
//       imagepath:
//           'https://images.unsplash.com/photo-1550348579-959785e820f7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8Z29hdHN8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
//       id: 20,
//       description: 'Bulk cows for sale',
//       price: 500000,
//       title: 'Cattle',
//       imagepath:
//           'https://images.unsplash.com/photo-1614005157364-67894d3dc531?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8Y2F0dGxlJTIwYWZyaWNhfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
//   ItemModel(
//            id: 21,
//       description: 'Piglets for sale',
//       price: 50000,
//       title: 'Piglets',
//       imagepath:
//           'https://images.unsplash.com/photo-1548781712-3da7f1a9dcd9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHBpZyUyMGZhcm18ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60')
// ];


List<TipsDeck> food = [
  TipsDeck(
      title: 'Stress of Going to the market',
      description: 'Well packaged!',
      imagepath:
          'https://images.unsplash.com/photo-1585540083814-ea6ee8af9e4f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8bmlnZXJpYXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
    ),
  TipsDeck(
      title: 'Where can i get fesh food?',
      description: 'Farmsies is a great option',
      imagepath:
          'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8bWFya2V0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
    ),
  TipsDeck(
      title: 'Eating green',
      description: 'Why must I eat veggies?',
      imagepath:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8bWFya2V0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
    ),
  TipsDeck(
      title: 'Supporting SME farmers',
      description: 'Go natural!',
      imagepath:
          'https://images.unsplash.com/photo-1509099342178-e323b1717dba?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YWZyaWNhbiUyMGZhcm18ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
    ),
  TipsDeck(
      title: 'Lagos Stress',
      description: 'Lets alleviate your stress!',
      imagepath:
          'https://images.unsplash.com/photo-1572816225927-d08fb138f2b2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8bmlnZXJpYXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
    ),
  TipsDeck(
      title: 'Making sellers lives easier',
      description:
          'Improving the customer base of the average foodstuff seller',
      imagepath:
          'https://images.unsplash.com/photo-1565958923272-e96dbb1e8414?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fG5pZ2VyaWF8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
    ),
  TipsDeck(
      title: 'Why fewer customers is a good thing',
      description: 'Croweded areas are so annoying',
      imagepath:
          'https://images.unsplash.com/photo-1533900298318-6b8da08a523e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bWFya2V0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
    ),
];

List foodcategories = [
  {
    'food name': 'Vegetables',
    'food icon': 'assets/Avatars/icons8-broccoli-100.png'
  }, //Done
  {
    'food name': 'Poultry',
    'food icon': 'assets/Avatars/icons8-chicken-96.png'
  }, //Done
  {
    'food name': 'Fruits',
    'food icon': 'assets/Avatars/icons8-pineapple-100.png'
  }, //Done
  {'food name': 'Fish', 'food icon': 'assets/Avatars/fish-food.png'},
  {
    'food name': 'Livestock',
    'food icon': 'assets/Avatars/icons8-cow-breed-80.png'
  }, //Done
  {
    'food name': 'Farmers advice',
    'food icon': 'assets/Avatars/icons8-gardener-100.png'
  }, //Done
  {
    'food name': 'Farm hands',
    'food icon': 'assets/Avatars/icons8-wheelbarrow-100 (1).png'
  }, //Done
  {
    'food name': 'Nuts and Berries',
    'food icon': 'assets/Avatars/icons8-nut-80.png'
  }, //Done
  {
    'food name': 'Vet services',
    'food icon': 'assets/Avatars/icons8-veterinary-examination-96.png'
  }, //Done
  {
    'food name': 'Garden & Farm services',
    'food icon': 'assets/Avatars/icons8-gardener-80.png'
  }, //Done
  {
    'food name': 'Farm tools',
    'food icon': 'assets/Avatars/icons8-wheelbarrow-100 (1).png'
  }, //Done
  {
    'food name': 'Farm machineries',
    'food icon': 'assets/Avatars/icons8-harvester-80.png'
  }, //Done
  {
    'food name': 'Honey',
    'food icon': 'assets/Avatars/icons8-hive-80.png'
  } //Done
];
