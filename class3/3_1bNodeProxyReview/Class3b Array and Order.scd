COLLECTIONS are objects that hold other objects, Array is the most commonly used.

Elements of an array with an integer index that ranges from  0 to 1  less than the size of the array.

ACCESSING ARRAY ELEMENTS
at(index) 					Return the item at index.
put(index, item)		Replace the object at index in the Array with item

Square brackets can be used as a shorthand for put and at

(
	x = [10,20,30];
	x.at(1);					// return second element
	x[0];						// return first element
	x.put(2, 44);			// change last element
	x[1] = 66;				// change middle element
)

The index may also be an array.
(
	x = [10,20,30];
	x[ [0,0,2,2,1] ];
	//[ 10, 10, 30, 30, 20 ] is returned
)

CHANGING ARRAY CONTENTS
For efficiency, arrays have a fixed amount of room for new elements.  Consequently, these methods sometimes need to create and return a new Array object to allocate additional space.

.add(item)				add an item to the end of the Array
.insert(index, item)

(
z = [1, 2, 3];
z.add(4);				// add a number to the end
z.postln;					// looks good
z.add(5);				// add another number
z.postln;					// whoops, it got lost
z = z.add(5);			// reassign to the variable to safeguard against that
)

An Order is similar to an Array in that it holds elements accessed by an index.
But that index can be a Float.
o = Order.new;
o[33] = "in front";
o[34] =  "in back";
o[33.5] = "in the middle";