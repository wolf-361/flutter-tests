// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // for saving suggested word pairings
  final _saved = <WordPair>{};
  // for saving favorited word pairings (use a set insterad of a list to prevent duplicates)
  final _biggerFont =
      const TextStyle(fontSize: 18); // for making the font bigger

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _saved.map((pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
          : <Widget>[];

      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Startup Name Generator'), actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          )
        ]),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            /* Callback once per row */
            if (i.isOdd)
              return const Divider(); /* if odd, add a divider (1 pixel height) */

            final index = i ~/ 2; /* calculates number of words minus divers */
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
              /* if reached end of suggestions list, generate more */
            }

            final alreadySaved = _saved.contains(_suggestions[index]);

            return ListTile(
                title:
                    Text(_suggestions[index].asPascalCase, style: _biggerFont),
                trailing: Icon(
                  // if already saved, show a filled heart, otherwise an empty one
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                ),
                onTap: () {
                  setState(() {
                    // call setState() to update the UI
                    if (alreadySaved) {
                      // if already saved, remove from saved
                      _saved.remove(_suggestions[index]);
                    } else {
                      // if not saved, add to saved
                      _saved.add(_suggestions[index]);
                    }
                  });
                });
          },
        ));
  }
}
