""" Hyphenation, using Frank Liang's algorithm.

    This module provides a single function to hyphenate words.  hyphenate_word takes 
    a string (the word), and returns a list of parts that can be separated by hyphens.
    
    >>> hyphenate_word("hyphenation")
    ['hy', 'phen', 'ation']
    >>> hyphenate_word("supercalifragilisticexpialidocious")
    ['su', 'per', 'cal', 'ifrag', 'ilis', 'tic', 'ex', 'pi', 'ali', 'do', 'cious']
    >>> hyphenate_word("project")
    ['project']
    
    Ned Batchelder, July 2007.
    This Python code is in the public domain.
"""

import re

__version__ = '1.0.20070709'

class Hyphenator:
    def __init__(self, patterns, exceptions=''):
        self.tree = {}
        for pattern in patterns.split():
            self._insert_pattern(pattern)
    
        self.exceptions = {}
        for ex in exceptions.split():
            # Convert the hyphenated pattern into a point array for use later.
            self.exceptions[ex.replace('-', '')] = [0] + [ int(h == '-') for h in re.split(r"[a-z]", ex) ]
                
    def _insert_pattern(self, pattern):
        # Convert the a pattern like 'a1bc3d4' into a string of chars 'abcd'
        # and a list of points [ 1, 0, 3, 4 ].
        chars = re.sub('[0-9]', '', pattern)
        #points = [ int(d or 0) for d in re.split("[.a-z]", pattern) ]
        points = [ int(d) if d.isdigit() else 0  for d in re.split("[^1-9]", pattern) ]

        # Insert the pattern into the tree.  Each character finds a dict
        # another level down in the tree, and leaf nodes have the list of
        # points.
        t = self.tree
        for c in chars:
            if c not in t:
                t[c] = {}
            t = t[c]
        t[None] = points
        
    def hyphenate_word(self, word):
        """ Given a word, returns a list of pieces, broken at the possible
            hyphenation points.
        """
        # Short words aren't hyphenated.
        if len(word) <= 4:
            return [word]
        # If the word is an exception, get the stored points.
        if word.lower() in self.exceptions:
            points = self.exceptions[word.lower()]
        else:
            work = '.' + word.lower() + '.'
            points = [0] * (len(work)+1)
            for i in range(len(work)):
                t = self.tree
                for c in work[i:]:
                    if c in t:
                        t = t[c]
                        if None in t:
                            p = t[None]
                            for j in range(len(p)):
                                points[i+j] = max(points[i+j], p[j])
                    else:
                        break
            # No hyphens in the first two chars or the last two.
            points[1] = points[2] = points[-2] = points[-3] = 0

        # Examine the points to build the pieces list.
        pieces = ['']
        for c, p in zip(word, points[2:]):
            pieces[-1] += c
            if p % 2:
                pieces.append('')
        return pieces

if __name__ == '__main__':
    import sys
    if len(sys.argv) > 1:
        f = open(sys.argv[1])
        patterns = "".join(f.readlines())
        f.close()
        hyphenator = Hyphenator(patterns)
        hyphenate_word = hyphenator.hyphenate_word
        for word in sys.argv[2:]:
            print('-'.join(hyphenate_word(word)))
