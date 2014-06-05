#Below was my solution to Kata 5, which asks us to implement a Bloom Filter.  
#(http://pragdave.me/codekata/kata/kata05-bloom-filters/)

#The methods below implement a simple bloom filter and various ways to test the filter's efficacy
#and other details.  The large majority of the file is a dictionary that is mapped into the 
#bitmap.  There are two separate hashing functions -- one using md5 and one with my own 
#version of a hash available online.  The md5 hash is vastly superior and gives false 
#positives around 1% for about 10x the number of bits as there are elements in the dictionary
#(according to wikipedia, this is approximately the error rate theoretically expected).

#The filter works by creating a space of around 3.5 million zeros, producing several hashes
#for each word in the dictionary, and changing the filter from 0 to 1 at those address points.
#To look up a new word, a lookup method hashes the word using the same method as was used for
#the entries in the dictionary and then looks at each of the index points of the filter to 
#see if they are switched on.  If all of the hashes are one, the filter returns true, indicating
#the word is in the dictionary.  

#I chose sizes of the filter (3,354,770) as well as a number of hash
#values per word (7) to produce a false positive rate of around 1%.  Testing with the tester 
#method, which generates however many random words you want and tests whether they are in 
#the dictionary using the bloom filter (then tests for "false false positives" by doing an 
#include? check on the array), has confirmed that error rates are below 1%.  However, using 
#the other hash method produces false positives around 10x as high (it appears that 
#the 1s are not nearly as well-distributed through the filter).

#It is really awesome that a dictionary with over 350,000 words can be represented in a 
#data structure of only around 400 kilobytes!  Increasing the size of the filter or the
#number of hashes per number can decrease the false positive rate to an arbitrarily small
#number at the expense of either space (increased filter size) or hashes (increased run time).
#These are especially useful if you need to cheaply (in terms of memory) and quickly check for membership in 
#a set and the possibility of false positives is not too devastating.  For example, 
#a spell checker could use something like this to flag misspelled words, although occasionally
#it will miss some.


require 'digest/md5'
require 'zlib'
DICTIONARY = File.readlines("dictionary.txt").map(&:chomp)

#N = number of entries.
#M = size of bitmap.
#K = number of hash functions on each entry.

#N is appx. 350,000 words.
#Optimal M equals 3,354,770 bits, or - ((n ln p)/((ln 2)^2)).  (See http://www.dca.fee.unicamp.br/~chesteve/pubs/bloom-filter-ieee-survey-preprint.pdf)
#K = (3,354,770/350,000) * ln2 = 6.6

#The first hash function, md5_hash_fill takes as arguments the size of the filter in bits 
#and the word to be hashed.  Then it calculates an MD5 hash of the word, converts it to 
#hexadecimal and then base 10, and takes 7 different slices of the resulting number (40 digits
#long) and stores them in an array of hashes, which is then returned.  Each "slice" of the 
#hash is given modulo the size of the array to both avoid numbers higher than the index of the
#filter and to increase the distribution over the entirety of the filter.  (Other methods were
#faster but did not produce nearly as well-distributed of hash values.)  There are two criteria
#for a good hash -- avalanche (or small changes in the input producing large changes in the 
#output) and even distribution over the entirety of the scale.  

#For example, "word" produces the following values:

#663270
#1230242
#663270
#2135886
#3232881
#2978689
#929401

#"work": 

#1075943
#2831291
#1075943
#954083
#1699218
#2929112
#2601829

#"fork":

#1743937
#1812522
#1743937
#1187683
#618047
#2089594
#2202509

#These three words are quite similar but yeild much different hashes.  They also 
#appear well-distributed over the indices from 0 to 3,354,770.  Tinkering with the 
#hash function until it resulted in lower than 1% false positives was the way I 
#arrived at this method of "slicing" a hash value.  Other methods -- incidentally,
#far more complex -- produced much worse results.

def md5_hash_fill(nBitArray, key)

  temp_key = Digest::MD5.hexdigest(key).hex.to_s(10)
  index = []
  index << temp_key.to_i % nBitArray
  index << temp_key.to_s.reverse.to_i % nBitArray
  index << temp_key.to_s[0..-1].to_i % nBitArray
  index << temp_key.to_s[1..-1].reverse.to_i % nBitArray
  index << temp_key.to_s[2..-2].reverse.to_i % nBitArray
  index << temp_key.to_s[3..-3].to_i % nBitArray
  index << temp_key.to_s[4..-4].to_i % nBitArray

  index

end

#The following was my attempt at creating my own hash function based on information
#online.  It does quite poorly and takes longer -- around 10% false positives and about
#5 times as slow -- as md5_hash_fill.

def rolled_hash_fill(nBitArray, key)

  hash = 0
  index = []
  key_characters = key.to_s.split('')

  key_characters.each do |character|
    hash = (hash << 5) - hash + character.ord 
  end

  7.times do |number|
    index << hash % nBitArray
    hash = hash.to_s[0..number].reverse.to_i
  end

  index

end

#The math for the size of bitmaps and number of hashes is below:
#N = number of entries.
#M = size of bitmap.
#K = number of hash functions on each entry.

#N is appx. 350,000 words.
#Optimal M equals 3,354,770 bits, or - ((n ln p)/((ln 2)^2)).  (See http://www.dca.fee.unicamp.br/~chesteve/pubs/bloom-filter-ieee-survey-preprint.pdf)
#K = (3,354,770/350,000) * ln2 = 6.6

#The bitmap_builder method simply hashes the contents of the "dictionary" file above.

def bitmap_builder(size)

  data = DICTIONARY
  bitmap = []

  #First it creates a blank bitmap as large as the user wants.  (Appx. 10 the number of 
  #data items is a decent size).

  for number in 1..size
    bitmap << 0
  end

  #Then it generates a hash for each word, checks to see whether the indexes at each of the
  #seven hash values are 0 and, if they are, sets them to 1.  (If they are already 1 from 
  #another word the values are left alone).

  data.each do |word|
    indices = md5_hash_fill(size, word)
    indices.each do |index|
      if bitmap[index] == 0
        bitmap[index] = 1
      end
    end
  end

  #The resulting bitmap "contains" -- in a sense -- all the words in the dictionary.  If any
  #other word is hashed in the same way and tested against the bitmap, if it is in the 
  #dictionary it will certainly be found (i.e., all the same indices will be 1), although
  #there is some chance that even if it's not in the dictionary it will also be "found"
  #because other words happened to set the same indices to 1.  This slight tradeoff, however,
  #is more than made up for by the speed of encoding and searching -- as well as the tiny
  #memory required (only appx. 400k) -- for the bloom filter as compared to simply storing the
  #words in an array and doing a standard "include?" to determine whether new words belong.

  bitmap

end

#When I was playing with different hash functions I realized that some resulted in very "clumpy"
#values, with many words obtaining the same -- or similar -- hashes.  Not surprisingly, this
#resulted in way too many false positives.  To test for clumpiness, I wrote the following simple
#method to count the number of 0s.  Although hypothetically the zeros could be in large clumps,
#in practice the better-distributed (and better performing) filters tended to have around 50/50
#1 to 0 ratios and, upon visual inspection, were not at all clumpy.  

def bitmap_investigator(bitmap)

  bitmap_bits = bitmap
  bitmap_size = bitmap.count

  counter = 0

  bitmap_bits.each do |bit|
    if bit == 0
      counter += 1
    end
  end

  puts "There are #{counter} 0s in the bitmap."
  puts "The percentage of 0s is #{(counter/bitmap_size.to_f)*100}."

end

#Below I run both the bitmap_builder and bitmap_investigator.  It takes 
#only 6.1 seconds to run both, and generates a filter with almost exactly 55%
#0s.

bitmap = bitmap_builder(3354770)

bitmap_investigator(bitmap)

#The look_up method hashes a word ("key"), tests whether each of the 
#resulting numbers correspond with a "1" at the index numbers of each 
#hash and, if they do, returns "true."

def look_up(key, nBitArray, bitmap)

  test = md5_hash_fill(nBitArray, key)

  #As soon as one of the index numbers is 0, it is definitely shown that
  #the word is NOT in the bitmap and the method returns false.

  test.each do |index|
    if bitmap[index] == 0
      return false
    end
  end

  true

end

#The following two methods test the filter above by generating 
#random words, testing to see whether the look_up method says
#they are included in the bitmap, and, if they are, testing to 
#see whether they actually are (if not, counting the "false positives").
#The resulting number is the number of false positives.  Running it 
#multiple times shows that using the md5 hash yields around 
#.8-1% false positives, which is the number theoretically expected with
#a filter of the size 3354770 and 7 hashes.  (Doing more hashes or 
#inreasing filter size can reduce the false positives to an arbitrarily
#small number but the resulting increased memory requirements and speed
#demands will eventually make the bloom filter just as "costly" as a 
#traditional method that tests for membership in a set.)

def random_word_generator(numberOfLetters)
  alphabet =* ('a'..'z') 
  word = []

  numberOfLetters.times do
    word << alphabet.sample(1)
  end

  word.join
end 

def tester(bitmap)

  count = 0
  random_words = []

  #Create list of 10000 random 5-letter words.

  10000.times {random_words << random_word_generator(5)}

  #Test if the word is included in the filter according to 
  #look_up and NOT in fact included ("false positives") and 
  #count and print the total number of those.

  random_words.each do |word|
    if look_up(word, 3354770, bitmap) == true && !DICTIONARY.include?(word)
      count += 1
    end
  end

  #Print the percentage of false positives.
  puts (count.to_f/10000) 

end

#Running tester 5 times yielded false positives of 108/10000, 116/100000, 114/100000, 123/10000,
#and 106/10000, with a mean of around 1.1%.  (Interestingly, if the words are 7 letters long, they are somewhat less likely
#to generate fewer false positives.)

tester(bitmap)



