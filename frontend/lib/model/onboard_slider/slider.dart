import 'package:flutter/material.dart';

class Slider {
  final String imageUrl;
  final String title;
  final String description;

  Slider({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slider(
    imageUrl: 'assets/images/icons/logo.png',
    title: 'Welcome to Dentime!',
    description:
        'Dentime is an online densits booking app that allows you to set a meeting with the dentists that you like!',
  ),
  Slider(
    imageUrl: 'assets/images/icons/onboardMap.png',
    title: 'Use The Map!',
    description:
        'Search for, and find your favorite dentists by using the map. Click on the dentist either on the map or on the lsit to see further information.',
  ),
  Slider(
    imageUrl: 'assets/images/icons/logo.png',
    title: 'Let\'s Get Started!',
    description:
        'Start by creating an account, exploring the dentist lists, their opening hour information, and start booking!',
  ),
];
