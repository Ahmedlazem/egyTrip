import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'city.dart';

class HotelOffers with ChangeNotifier {
  final String hotelName;

  final String city;
  final String companyName;
  final String companyPhone;
  final String companyMail;
  final String startDeal;
  final String endDeal;

  final List<dynamic> price;

  //List<dynamic>
  //List<Map<String, Object>>
  final String hotelId;
  final String id;

  // bool isFavorite;

  HotelOffers({
    this.startDeal,
    this.endDeal,
    this.city,
    this.price,
    this.hotelName,
    this.hotelId,
    this.id,
    this.companyName,
    this.companyPhone,
    this.companyMail,
    //this.isFavorite = false
  });

  List<HotelOffers> hotelOffersList = [];
  List<HotelOffers> bestOffersList = [];

  Future<void> fetchHotelsCity(String selectedCity) async {
    try {
      print('start get city hotel from firebasae $selectedCity');
      final List<HotelOffers> loadedProducts = [];
      await FirebaseFirestore.instance
          .collection('Hotels Offers')
          .where('city', isEqualTo: selectedCity)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          notifyListeners();
          // if deal of customer was finished not add to list
          if (DateTime.parse(result.data()["end Deal"])
              .isBefore(DateTime.now())) {
            return;
          }
          print(
            result.data()["hotel Id"],
          );
          print(
            result.data()["hotel name"],
          );
          loadedProducts.add(HotelOffers(
            id: result.id,
            city: result.data()['city'],
            hotelId: result.data()["hotel Id"],
            price: result.data()['price'],
            hotelName: result.data()["hotel name"],
            companyMail: result.data()["company mail"],
            companyName: result.data()["company name"],
            companyPhone: result.data()["company phone"],
          ));
        });

        hotelOffersList = loadedProducts;

        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchBestDeal() async {
    try {
      print('start get best deal from firebase');
      final List<HotelOffers> loadedProducts = [];
      await FirebaseFirestore.instance
          .collection('Hotels Offers')
          .where('city', isEqualTo: "Best Deal")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          notifyListeners();
          // if deal of customer was finished not add to list
          if (DateTime.parse(result.data()["end Deal"])
              .isBefore(DateTime.now())) {
            return;
          }
          print(
            result.data()["hotel Id"],
          );
          print(
            result.data()["hotel name"],
          );
          loadedProducts.add(HotelOffers(
            id: result.id,
            city: result.data()['city'],
            hotelId: result.data()["hotel Id"],
            price: result.data()['price'],
            hotelName: result.data()["hotel name"],
            companyMail: result.data()["company mail"],
            companyName: result.data()["company name"],
            companyPhone: result.data()["company phone"],
          ));
        });

        bestOffersList = loadedProducts;

        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

//ignore: missing_return

List<City> cityList = [
  City(cityName: "Sharm El-Shikh", long: 34.311312, lat: 27.859584, cityDis: {
    'imageUrl': "assets/image/sharm.gif",
    // 'https://media.giphy.com/media/X5SVHfNzbPQJquFigW/giphy-downsized.gif',
    'en_US':
        "Diverse marine life and hundreds of Red Sea coral reef sites make Sharm El Sheikh a magnet for divers and eco-tourists. The tourist economy of this Sinai Peninsula city has grown quite rapidly over the last few decades, resulting in an upcrop of first-class resorts and posh nightlife. The waters of Ras Mohamed National Park are abundant with schools of fish and, oddly, toilets – thanks to the bathroom fixtures being transported by a cargo ship that sank during a 1981 storm.",
    'ar_AR':
        'تجعل الحياة البحرية المتنوعة ومئات المواقع للأعشاب المرجانية في البحر الأحمر من شرم الشيخ مدينة جاذبة للغواصين والسائحين البيئيين. فلقد شهدت صناعة السياحة في مدينة شبه جزيرة سيناء هذه نموًا سريعًا على مدى العقود القليلة الماضية، حيث أثمرت عن مجموعة من المنتجعات من الدرجة الأولى والحياة الليلية المترفة. تزخر مياه "محمية رأس محمد الوطنية" بمجموعات من الأسماك، والأشياء غريب الشكل ومستحضرات دورات المياه - حيث يرجع السبب في ذلك إلى غرق سفينة الشحن التي كانت تنقل تجهيزات للحمامات خلال عاصفة هبت عام 1981.'
  }),
  // City(cityName: 'Nabq Bay', long: 34.417317, lat: 28.016034),
  // City(cityName: 'Sharm Old Market', long: 34.295808, lat: 27.865542),
  // City(cityName: 'Naama Bay', long: 34.326752, lat: 27.914885),
  //City(cityName: 'Sharks Bay', long: 34.393251, lat: 27.963000),
  City(cityName: 'Hurghada', long: 33.8116, lat: 27.2579, cityDis: {
    'imageUrl': "assets/image/hurghada.gif",
    // 'https://media.giphy.com/media/v2eFGJtervfVUpsMkm/giphy-downsized.gif',
    'en_US':
        "Stunning coral reefs and turquoise waters perfect for windsurfing have made Hurghada, on Egypt's Red Sea Coast, a busy resort town. Within easy reach of the stunning Giftun Islands and the Eastern Arabian Desert, Hurghada has seen enormous amounts of development in the past decade—and yes, it does seem overrun with tourists at times. But it’s a relatively easy beach escape for Europeans, and some of the world's best diving and snorkeling sites are just offshore. Walk or catch a cab to explore the old quarter, El Dahar.",
    'ar_AR':
        'تتسم مدينة الغردقة، الواقعة على ساحل البحر الأحمر في مصر، بشعاب مرجانية خلابة ومياه فيروزية مثالية لركوب الأمواج مما جعل منها منتجعًا يعج بالسياح. ونظرًا لإمكانية الوصول السهل لجزر الجفتون الخلابة والصحراء العربية الشرقية من خلالها، شهدت الغردقة كمًا كبيرًا من عمليات التطوير خلال العقد الماضي - وبالتأكيد فإن عدد السياح بها يفوق الخيال في كثير من الأحيان. فشواطئها تعد ملاذًا سهلاً نسبيًا للأوروبيين، وتقع في مياهها وقبالة سواحلها أفضل أماكن الغوص والغطس بالمعدات في العالم. تمتع بالتجول سيرًا على الأقدام أو استقل سيارة أجرة لتفقد الحي القديم المعروف باسم الدهار.'
  }),
  City(cityName: "El-Gona", lat: 27.4025, long: 33.6511, cityDis: {
    'imageUrl': "assets/image/elgona.gif",
    // 'https://media.giphy.com/media/O6SaPjewQPUVJAzHT4/giphy-downsized.gif',
    'en_US':
        "Come play in El Gouna where the turquoise Red Sea sparkles. With resorts, spas and an 18-hole golf course, El Gouna lets you unwind under the sun. Book an excursion by land or sea—quad bikes are a popular way for the adventurous to see the desert. By night, trendy bars and the open-air disco welcome you to stay up late",
    'ar_AR':
        'تعال وتمتع باللعب والمرح في الجونة حيث يتألق البحر الأحمر ذو اللون الفيروزي. ومن خلال ما تتمتع به من منتجعات شاطئية صحية وملعب جولف به 18 حفرة، ستتيح لك الجونة التمتع بالاسترخاء تحت أشعة الشمس - بادر بالحجز للقيام بنزهة برية أو بحرية. وفي هذا، تعد الدراجات الرباعية أشهر وسيلة للمغامرة من أجل التمتع بمشاهدة الصحراء. وفي الليل، تلقى ترحيبًا شديدًا من الملاهي الليلية الأنيقة وصالات الديسكو في الهواء الطلق لتستمتع بقضاء سهرتك فيها لوقت متأخر'
  }),
  City(cityName: "Marsa Alam", lat: 25.0676, long: 34.8790, cityDis: {
    'imageUrl': "assets/image/marsa.gif",
    // 'https://media.giphy.com/media/9rVpTniRCRdDuVqEjm/giphy-downsized.gif',
    'en_US':
        "Thanks to the addition of an international airport in 2001, Marsa Alam is fast becoming a premium tourist destination, especially for scuba divers. The waters here are brimming with marine life and pristine dive sites. Landlubbers, don’t miss the Emerald Mines and the Temple of Seti I at Khanais",
    'ar_AR':
        'بفضل إضافة المطار الدولي عام 2001، أصبحت مرسى علم سريعًا وجهة سياحية أساسية خاصة بالنسبة لمن يغوصون بالمعدات. تتميز المياه هنا بالحياة البحرية وأماكن الغوص الأصلية. وبالنسبة لمن لا يحبون السباحة فلا تفوتهم مناجم الزمرد ومعبد سيتي الأول في خانايس.'
  }),
  // City(cityName: "Porto Ghalib", lat: 25.5354, long: 34.6375),
  // City(cityName: "Sahl Hasheesh", lat: 27.0370, long: 33.8523),
  City(cityName: 'Dahab', lat: 28.5091, long: 34.5136, cityDis: {
    'imageUrl': "assets/image/dahab.gif",
    //  'https://media.giphy.com/media/JeKqTDsOt4K69TtQKa/giphy-downsized.gif',
    'en_US':
        "This former Bedouin fishing village is now a popular tourist destination—especially for serious windsurfers, who'll find some of the best conditions in the world off Dahab's beaches. Long known as a laid-back, backpacker-friendly town, Dahab is becoming more developed, yet retains a casual vibe. Finally, Dahab is also home to the Blue Hole, the world's most dangerous dive site. Only very experienced technical divers should attempt passage through The Arch here; if you're a novice diver, stay close to the surface",
    'ar_AR':
        'أصبحت مدينة دهب قرية صيد السمك البدوية السابقة الآن وجهة سياحية شهيرة، وخاصة بالنسبة لهواة ركوب الأمواج ممن يحبون المغامرات، والذين سيجدون إلى حد ما أفضل الظروف والأحوال الجوية في العالم في شواطئها. وقد اشتهرت هذه المدينة منذ وقت طويل بأنها مدينة تتسم بالهدوء وبإقامة المعسكرات حيث إنها تجذب دائمًا المسافرين والمرتحلين، وهي أصبحت الآن أكثر تطورًا، غير أنها تحتفظ بطابعها العادي والتقليدي. وفي النهاية، فهي أيضًا المكان الذي توجد فيه حفرة البلو هول، التي تعد أخطر مناطق الغوص في العالم. ويتعين فقط على الغواصين الذين يتمتعون بخبرات فنية عالية المرور من خلال ما يعرف بـ "القنطرة" في هذه الحفرة. إذا كنت غواصًا مبتدئًا، فيتعين أن تبقى قريبًا من السطح'
  }),
  // City(cityName: "Makadi", lat: 26.9886, long: 33.8996),
  // City(cityName: "Soma Bay", lat: 26.8482, long: 33.9900),
  City(cityName: 'Taba', lat: 29.4925, long: 34.8969, cityDis: {
    'imageUrl': "assets/image/taba.gif",
    // 'https://media.giphy.com/media/VSZELUCkeTXFXHL4aD/giphy-downsized.gif',
    'en_US':
        "Taba, situated on the Red Sea's Gulf of Aqaba at the junction of Egypt and Palestine, is a stone's throw from a truly impressive range of sites.  Excursions to nearby Castle Zaman provide a rare view of four countries simultaneously, and the Colored Canyon is an obstacle course ripe for exploration.  The Marriott Taba Heights Red Sea Resort awaits tourists following their day trips with its very own therapeutic Salt Cave, ideal for unwinding in luxury.",
    'ar_AR':
        'تعتبر طابا، التي تقع على خليج البحر الأحمر في العقبة عند تقاطع مصر و فلسطين، على مرمى مسافة قريبة من مجموعة من المواقع المثيرة للإعجاب حقًا. وتقدم الرحلات إلى قلعة زمان القريبة رؤية نادرة لأربع دول في وقت واحد، كما تعتبر الجبال الملونة بقعة يحلو استكشافها. بينما ينتظر منتجع ماريوت مرتفعات طابا بالبحر الأحمر السياح بعد قضاء رحلات يومية حيث كهف الملح العلاجي المميز، الذي يعد مثالي للاسترخاء في الترف.'
  }),
  // City(cityName: "Safaga", lat: 26.7500, long: 33.9360),
  // City(cityName: "El-Quseer", lat: 26.1014, long: 34.2803),
  City(cityName: "El-Sokhna", lat: 29.6725, long: 32.3370, cityDis: {
    'imageUrl': "assets/image/elsokhna.gif",
    //   'https://media.giphy.com/media/KwD9yXyWX4VmdkX39I/giphy-downsized.gif',
    'en_US':
        "It was called Ain Sokhna due to the large number of hot sulfur eyes in it, which are used for healing. It has non-rocky beaches with white sand, and it is considered a resort throughout the months of the year, summer and winter, and there are several tourist areas and villages that contain hotels and chalets. The Ain Sokhna Hotel, which was established in the early sixties, is the oldest ever, and its proximity to Cairo - where it is about 140 km away from it. Approximately kilometers - making it a preferred resort for Egyptians, especially for a one-day trip, even if the percentage of foreign tourists is predominant, and several tourism projects are being established in the Ain Sokhna area to attract the increasing numbers of Egyptian and foreign tourists",
    'ar_AR':
        'سميت بالعين السخنة لكثرة العيون الكبريتية الساخنة بها والتي تستخدم للاستشفاء. وبها شواطئ غير صخرية ذات رمال بيضاء، كما أنها تعتبر مصيفا طوال أشهر السنة صيفا وشتاء، ويوجد بها عدة مناطق وقرى سياحية تحوي فنادق وشاليهات ويعد فندق العين السخنة الذي أُنشئ في أوائل الستينيات أقدمها على الإطلاق، وقربها من القاهرة - حيث تبعد عنها بمسافة حوالي 140 كيلومترا تقريبا - جعلها مصيفا مفضّلا للمصريين خصوصا لرحلة اليوم الواحد، وإن كانت نسبة السياح الأجانب بها هي الغالبة، ويتم بمنطقة العين السخنة إنشاء عدة مشاريع سياحية لجذب الأعداد المتزايدة من السياح المصريين والأجانب'
  }),
  City(cityName: "Cairo", lat: 30.0444, long: 31.2357, cityDis: {
    'imageUrl': "assets/image/cairo.gif",
    //  'https://media.giphy.com/media/Eow5e392MXgVfW13Sk/giphy-downsized.gif',
    'en_US':
        "Cairo’s an ancient city that also happens to be a modern metropolis—it’s one of the biggest cities in the Middle East and has the traffic and noise issues to prove it. But as long as you’re not looking for solitude, Cairo—the City of the Thousand Minarets—is a splendid place to explore Egyptian history and culture.",
    'ar_AR':
        'تعد القاهرة مدينة قديمة واكبت التطور حتى أصبحت أيضًا عاصمة حديثة. فهي تعتبر واحدة من أكبر المدن في الشرق الأوسط وبها مشكلات مرور وضوضاء تثبت ذلك. لكن طالما أنك لا تبحث عن الانعزال، فإن القاهرة - مدينة الألف مئذنة - تعد مكانًا رائعًا لاستكشاف التاريخ والحضارة المصرية.'
  }),
  // City(cityName: "Fifth Settlement", lat: 30.0084868, long: 31.4284756),
  // City(cityName: "Heliopolis", lat: 30.115469, long: 31.346512),
  // City(cityName: "Giza", lat: 30.0131, long: 31.2089),
  // City(cityName: "El Maadi", lat: 29.963200, long: 31.317997),
  // City(cityName: "Nasser City", lat: 30.069505, long: 31.341665),
  // City(cityName: "October city", lat: 29.996013, long: 30.97875),
  City(cityName: "Luxor", lat: 25.6872, long: 32.6396, cityDis: {
    'imageUrl': "assets/image/luxor.gif",
    // 'https://media.giphy.com/media/O2EyOJZbJl5sRspjed/giphy-downsized.gif',
    'en_US':
        "Luxor was distinguished by its location in a vast fertile plain, where the eastern desert recedes to the east, and the riverbed was wide between it and the western shore, where the western desert is close to the Nile River, on which an ancient civilization has emerged, as evidenced by spacious temples, huge monuments and tall obelisks. The history of mankind in that region goes back to the Paleolithic period. But we bet you will enjoy its beautiful weather by flying in a hot air balloon over the Valley of the Kings, which is much brighter.",
    'ar_AR':
        'امتازت الاقصر بموقعها في سهل فسيح خصب حيث ترتد الصحراء الشرقية إلى الشرق وكان مجرى النهر عريضاً بينها وبين الشاطئ الغربي حيث تقترب الصحراء الغربية من نهر النيل الذي قامت على ضفتيه حضارة قديمة تشهد عليها المعابد الفسيحة والصروح الضخمة والمسلات الشاهقة. يرجع تاريخ الإنسان في تلك المنطقة إلى العصر الحجري القديم. لكننا نراهن أنك ستستمتع  بطقسها الجميل و بالتحليق بمنطاد الهواء الساخن فوق وادي الملوك الذي يعد أكثر إضاءة. '
  }),
  City(cityName: "Aswan", lat: 24.0928, long: 32.8968, cityDis: {
    'imageUrl': "assets/image/aswan.gif",
    // 'https://media.giphy.com/media/ZZ7EllGSxuPGqswKGX/giphy-downsized.gif',
    'en_US':
        "Aswan is more idyllic than other cities in Egypt—located in southern Egypt, it’s a great place to explore that country’s epic history far away from the chaos of Cairo. Take a traditional wooden felucca around Elephantine Island and explore the ruins of the Temple of Khnum.",
    'ar_AR':
        'تعد أسوان أكثر مدن مصر شاعرية - فهي تقع في جنوب مصر، وهي مكان رائع ستتمتع فيه باكتشاف التاريخ الملحمي لهذه البلدة بعيدًا عن زحام القاهرة. فهناك، يمكنك ركوب الفلوكة والتجول بها حول جزيرة فيلة فضلاً عن استكشاف أطلال معبد خنوم.  '
  }),
  City(cityName: "Alexandria", lat: 31.2001, long: 29.9187, cityDis: {
    'imageUrl': "assets/image/alex.gif",
    // 'https://media.giphy.com/media/3ufsLLPYjAMJ6XjW7o/giphy-downsized.gif',
    'en_US':
        "The Pearl of the Mediterranean has an ambiance more in keeping with its neighbors to the north than with those in the Middle East. Site of Pharos lighthouse, one of the Wonders of the World, and of Anthony and Cleopatra’s tempestuous romance, the city was founded by Alexander the Great in 331 BCE. Today, Alexandria offers fascinating insights into its proud Greek past, as well as interesting mosques, the casino strip of the Corniche, some lovely gardens and both modern and traditional hotels.",
    'ar_AR':
        'تتسم لؤلؤة البحر الأبيض المتوسط بأجواء تجعلها أكثر انسجامًا مع جيرانها في الشمال عن جيرانها في الشرق الأوسط. إنها مدينة الإسكندرية التي أسسها الإسكندر الأكبر في عام 331 قبل الميلاد، وتضم بين جنباتها منارة فاروس (الإسكندرية) التي تعد واحدة من عجائب الدنيا السبع وكانت مكانًا لقصة حب رومانسية عنيفة نشأت بين كل من أنطونيو وكليوباترا. وفي الوقت الحالي تضم الإسكندرية معالم رائعة تشهد على التاريخ اليوناني العظيم، إلى جانب المساجد الجميلة ومجموعة من الكازينوهات الممتدة على الكورنيش وبعض الحدائق الخلابة والفنادق الحديثة والقديمة.'
  }),
  City(cityName: "Best Deal", lat: 0.0, long: 0.0),
];
