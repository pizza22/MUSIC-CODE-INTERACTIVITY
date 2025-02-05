A quick review of what we discussed in the last class.

Object				every entity in the language is an object
Interface			objects provide an interface through which they may be used
Method			the interface consists of a collection of named methods
Class				A Class defines  the interface and internal structure of a kind of object

Every object is an instance of a Class. Every Class has a unique capitalized name.
All methods have names beginning with a lowercase letter.  Classes and methods comprise are basic building blocks of the language.

Doing things in SuperCollider involves creating objects that are instances of those classes and using their methods.

Learning to do things with SuperCollider involves learning about different Classes and their interfaces.  The help interface is organized around Classes and methods.
The single easiest way to get started is to focus on an appealing example, check help for every Class and method name you find and work out how it does what it does.

Here are the classes we discussed
Integer			// 3, 5, 1234
Float				// 0.3, 54.3, 345e66
						// .3 ERROR! must be 0.3.  3. ERROR! must be 3.0
String				// "This is a String"
Array				//  [1,2,3]

A given method  may be defined differently by different classes.  There is a specialized terminology that serves to emphasize this.

Performing a method is called "sending a message"
The 'receiver' is the object performing the method.
The 'selector' is the name of the method being performed.

Knowing the class of the receiver is the only way to be sure you understand what a message is doing.

For example, String implements 'help' differently than other classes.
3.help					//open help for Integer, the class of 3
4.0.help				//open help for Float, the class of 4.0
[3,5].help			//open help for Array, the class of
"UGen".help		// open help for UGen, rather than String
"String".help		// open help for String
Strings open help based on the contents of the String while other kinds of objects open the helpfile for their Class.
"play".help;
This is  an example of 'polymorphism', which is a Good Thing.

We then discussed methods with parameters, who arithmetic is written, and the fact that arithmetic associates to the left.

55.lcm(7);		// receiver notation
lcm (55,7);		// functional notation
55 lcm: 7;		// in-line notation -  applies to methods requiring a single parameter

2 + 3 * 4			// ambiguous expression
2 + (3 * 4)		// it might be evaluate this way
(2 + 3 ) * 4		// but supercollider evaluates it this way


We then discussed pitches expressed as MIDI key numbers and as frequencies and intervals expressed as MIDI key numbers or as ratios.  And used the following methods to convert between them.

midicps
cpsmidi
midiratio
ratiomidi

And we ended up using Arrays to define scales and  played those scales as clusters using a synthesis function we did not discuss.

We also introduced variables, which are simply names that can be assiged to an object that can then be used as a shorthand.

a = [1,2,4,7];			//assign the array to 'a'
a;								// now a returns the array as its value

We also showed how we can use a variable to write a complex message sequence
as a sequence of simple messages.
So the message sequence:
[1, 9/8,5/4, 4/3, 3/2, 5/3, 7/4].ratiomidi.round(0.01);  // gnarly message sequence


a = [1, 9/8,5/4, 4/3, 3/2, 5/3, 7/4];
a = a.ratiomidi;
a = a.round(0.01);

