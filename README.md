## Info

Simple API for the fortune program, using the Yesod framework. Surely a
completely overkill use of Yesod, but its a very basic example of an instance of
Yesod and it works. Based on the minimal scaffolding from 
[https://github.com/yesodweb/stack-templates](here).

## API Usage

You can test the API at the following URL:

    https://lt20kmph.co.uk/fortune

It accepts the following parameters via a query string:

    offensive = yes | no | both 
    shortorlong = short | long 
    length = INT 

All three parameters are optional. Note that the length parameter only has an
effect if either short or long fortunes are requested. In case short fortunes
are requested the length is the maximum length in characters of fortunes which
will be considered to be short.  In case long fortunes are requested then the
length is a minimum.  Without any parameters offensive defaults to no. Set
offensive equal to yes if you only want potentially offensive fortunes. See
[https://linux.die.net/man/6/fortune](man fortune) for more details.

## Example

Using curl:

    curl 'https://lt20kmph.co.uk/fortune?offensive=yes&shortorlong=short&length=35'



