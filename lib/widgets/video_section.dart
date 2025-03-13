import 'package:flutter/material.dart';

class VideoSection extends StatelessWidget {
  const VideoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFB5DADA),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Person on left chair
          _buildPerson(
            isLeftSide: true,
            hairColor: Colors.amber,
            topColor: Colors.white,
            bottomColor: Colors.red.shade300,
          ),

          // Person on right chair
          _buildPerson(
            isLeftSide: false,
            hairColor: Colors.red.shade300,
            topColor: Colors.red.shade400,
            bottomColor: Colors.blue.shade900,
          ),
        ],
      ),
    );
  }

  Widget _buildPerson({
    required bool isLeftSide,
    required Color hairColor,
    required Color topColor,
    required Color bottomColor,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 140,
          child: Stack(
            children: [
              // Chair
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Chair legs
              Positioned(
                bottom: 0,
                left: 10,
                child: Container(
                  height: 20,
                  width: 5,
                  color: Colors.brown.shade300,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: Container(
                  height: 20,
                  width: 5,
                  color: Colors.brown.shade300,
                ),
              ),

              // Person
              Positioned(
                top: 10,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    // Head
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          // Hair
                          Container(
                            width: 30,
                            height: 20,
                            decoration: BoxDecoration(
                              color: hairColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                          ),

                          // Glasses if on left
                          if (isLeftSide)
                            Positioned(
                              top: 12,
                              left: 5,
                              child: Container(
                                width: 20,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Body
                    Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: topColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),

                    // Legs
                    Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        color: bottomColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
