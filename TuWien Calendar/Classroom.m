

#import "Classroom.h"


@implementation Classroom

@synthesize address=_address;
@synthesize name=_name;
@synthesize location=_location;
@synthesize type=_type;
@synthesize pdf_link_cms=_pdf_link_cms;

//@synthesize building;




-(Classroom *)initWithName:(NSString*)name1
                   address:(NSString*)address1
                  location:(NSString*)location1
                      type:(NSString*)type1
                   pdflink:(NSString*)pdflink1{
    if (self = [self init]) {
		//[self setValuesForKeysWithDictionary:properties];
		self.address = address1;
		self.name = name1;
		self.location =location1;
		self.type = type1;
		self.pdf_link_cms = pdflink1;
    
        
	}
	return self;
}




-(void)dealloc{
	[_name release];
	[_address release];
	[_location release];
	[_type release];
	[_pdf_link_cms release];
	[super dealloc];
}

@end
