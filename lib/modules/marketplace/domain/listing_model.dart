import 'package:flutter/material.dart';

class MachineryListing {
  const MachineryListing({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.metaLine,
    required this.imageUrl,
    required this.location,
    this.featured = false,
    this.tags = const [],
    this.primaryActionLabel = 'Contact Seller',
    this.primaryActionIcon = Icons.call,
    this.outlineAction = false,
    this.year = '',
    this.hours = '',
    this.make = '',
    this.engine = '',
    this.postedAgo = '',
    this.sellerName = '',
    this.sellerNote = '',
    this.sellerAddress = '',
  });

  final String id;
  final String title;
  final String subtitle;
  final String priceLabel;
  final String metaLine;
  final String imageUrl;
  final String location;
  final bool featured;
  final List<String> tags;
  final String primaryActionLabel;
  final IconData primaryActionIcon;
  final bool outlineAction;
  final String year;
  final String hours;
  final String make;
  final String engine;
  final String postedAgo;
  final String sellerName;
  final String sellerNote;
  final String sellerAddress;

  static List<MachineryListing> demoListings = [
    const MachineryListing(
      id: '1',
      title: 'Millat Massey Ferguson MF 385 4WD (85 HP)',
      subtitle: '2022 • 450 Hours • Faisalabad',
      priceLabel: 'PKR 3,450,000',
      metaLine: '2022 • 450 Hours • Faisalabad, Punjab',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDcXHgTNkXhRhIXEKFI4BSwmCWbfGpAJ4-OgWiOEz6Bos0b9bOokBnQz74ZAr4bqazryt_eZC5EdJdvnol_EKokH-RORAS65ic9VZKKy3cMmCQSIzlXystOHkbto9gcnwfPjYqZUoLSYTIlOD82U--Ian-OHHhEmEEqJZ9mIWrwLTRpS7HGKacBt6x4AD7ZAyWXG6GVw8CjQHUtuovZ3atsNgXjK2ZOKzzQr-R9xRU',
      location: 'Faisalabad, Punjab',
      featured: true,
      tags: ['Verified Seller', 'Registered 2022', 'First Owner'],
      year: '2022',
      hours: '450 Hrs',
      make: 'Millat / MF',
      engine: '85 HP Diesel',
      postedAgo: '2 days ago',
      sellerName: 'Chaudhry Agricultural Machinery',
      sellerNote:
          'Complete genuine paint, single-hand owner driven on personal farm wheat and sugarcane fields. 100% genuine water pump, radiator, and differential seal locked.',
      sellerAddress: 'Jhang Road, Grain Market Bypass, Faisalabad',
    ),
    const MachineryListing(
      id: '2',
      title: 'Al-Ghazi New Holland Fiat 480 (55 HP)',
      subtitle: '2020 • 920 Hours • Sargodha',
      priceLabel: 'PKR 1,650,000',
      metaLine: '2020 • 920 Hours • Sargodha, Punjab',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCCKA2th-aX5p_Un5bJM-8XT0umZIVWvVgMVRkfobFAhycsOOaQHLrlD8xahwwXsf2mn4CiwZJhYzY-EVkb85-s3X1qPt6bScqbsBL3IUN7uTJ2AfBqRNywuhxfNaDQoVPZQJVN053v_SpKO-pev--2n02CWvr2J1gwJWZi3XEhfKVt31vBIrrU5r3ArUVSFfGbsHvxczhGvZ9PUcls3rVzGnhkHwYPcIZnWhHSV8o',
      location: 'Sargodha, Punjab',
      featured: true,
      tags: ['Complete Documents', 'Showroom Condition'],
      primaryActionLabel: 'Call Dealer',
      primaryActionIcon: Icons.support_agent,
    ),
    const MachineryListing(
      id: '3',
      title: 'John Deere Green Combine Harvester W70',
      subtitle: '2019 • Model 70 • Multan',
      priceLabel: 'PKR 8,900,000',
      metaLine: '2019 • Model 70 • Multan, Punjab',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBcKEO6C9V6oWq2zdSAu8QyWTKnxj_Etqaea8ohz8sSx7a9EjiLPCBz6vWePtjPSTIclFP83ut5-Hy1zj8R0VT2C9w6OpwsEizamH1B-H8nYLgJQJcRuNtqXxEZagsg_yl4H-WcXq_xykzGVrmkNKzY50mgbVf7qAErXq_p9Uq-intyWkyOy36ij7GOrVLk1n0bUDy66A6ch8KgilE98A2bBCZbStCvfX7CgpaMwLU',
      location: 'Multan, Punjab',
      primaryActionLabel: 'View Details',
      primaryActionIcon: Icons.visibility,
      outlineAction: true,
    ),
    const MachineryListing(
      id: 'search-1',
      title: 'Massey Ferguson 385 4WD',
      subtitle: '2021 • 680 Hours • Gujranwala',
      priceLabel: 'PKR 3,250,000',
      metaLine: '2021 • 680 Hours • Gujranwala',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBMSQabvbTDQjpsCx3NEAc48F2NkUHtitWr6ppdCP1CgcXy2DgZjgcGVk1m8p4Rmvl4HzTFen3zzxCZOtPuPeu6SbOUCdSuhR7ohb1h38J67wTMNwvJQoyC0HqNEtFk6sL1Y4IZvMss53rcGejVKZHm0Pt-pexuEZbhcFFb-rs6Rg8g2-lovSCRdUR-p9B64kbGTWKvbc-CYSllRccmUkReQmEEcOy_xjeG6Y2JDdY',
      location: 'Gujranwala',
      featured: true,
      primaryActionLabel: 'Chat with Seller',
      primaryActionIcon: Icons.chat,
    ),
    const MachineryListing(
      id: 'search-2',
      title: 'Heavy Duty 11-Tine Cultivator',
      subtitle: 'Rotavator Set • New • Sahiwal',
      priceLabel: 'PKR 480,000',
      metaLine: 'Rotavator Set • New Condition • Sahiwal',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAoMxIspYyA-_6aSK8ePCASnPWVvp7IA8iXwEaLqQzUnOzNFLPhjTBeL6-GDqXfKoVA2AmtzpMEkWGBKw11GZVJh0TWqPNtzeMUFA0Kx_XIz1exNu37_PUj7JC5KmDe8YbhicEVeLSZHvfLU4xC0zQ5PtJT8Z_BgL1Y7siXwFtgae6ieRFilkJYLLQJ7BL_Mkt0oaUMqp_K4xRu1W8lqjko3YIHI4IIYiWwofIr0n8',
      location: 'Sahiwal',
      primaryActionLabel: 'View Specs',
      primaryActionIcon: Icons.info_outline,
      outlineAction: true,
    ),
    const MachineryListing(
      id: 'search-3',
      title: 'Fiat 480 Al-Ghazi (55 HP)',
      subtitle: '2019 • 1,100 Hours • Bahawalpur',
      priceLabel: 'PKR 1,580,000',
      metaLine: '2019 • 1,100 Hours • Bahawalpur',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAIc3vEYy-oBG60yIy7SxJQJQ2I2qKGMtDpwoxRQD6U2UP8_PcgaqfEuILNPUhYTgbLA5yT8WMvkKHPBFLoDB69YYEP5JlGglwHF8s_uONzeLUnfsLmT5xWj6eEOKkO2YVkmTgxPW1fx-RclIENAVxRj4Z4jEqPw1PBcQvIwnBMaXa77j1OTMZKz4UHpaKCF0Zrmoi0gGvyJbbr_wurIOxAppP0AeKG_-m-fNv5LWU',
      location: 'Bahawalpur',
      primaryActionLabel: 'Call Seller',
      primaryActionIcon: Icons.call,
    ),
  ];
}
