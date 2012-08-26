//
//  PersonsListTableController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "PersonsListTableController.h"
#import "PersonTableViewCell.h"

#pragma mark -
#pragma mark Private constants

static NSString * const kPersonCellIdentifier = @"Person Cell";


#pragma mark -
#pragma mark PersonsListTableController implementation

@implementation PersonsListTableController

#pragma mark -
#pragma mark public: CoreDataTableViewController

- (NSFetchRequest *) fetchRequest
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: @"Person"];
    
    NSArray *sortDescriptors =
    @[[NSSortDescriptor sortDescriptorWithKey: @"lastName"       ascending: YES],
     [NSSortDescriptor sortDescriptorWithKey: @"firstName"      ascending: YES],
     [NSSortDescriptor sortDescriptorWithKey: @"patronymicName" ascending: YES]
    ];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    return fetchRequest;
}


- (NSString *) sectionNameKeyPath
{
    return @"nameSectionID";
}


- (UITableViewCell *) tableView: (UITableView *) tableView
           cellForManagedObject: (Person *) person
                    atIndexPath: (NSIndexPath *) indexPath
{
    NSAssert([person isKindOfClass: [Person class]],
             @"Expected object of class Person");
    
    PersonTableViewCell *cell = (id)[tableView dequeueReusableCellWithIdentifier: kPersonCellIdentifier];
    NSAssert([cell isKindOfClass: [PersonTableViewCell class]],
             @"PersonsListTableController requires a PersonTableViewCell instances "
             @"to be registered for the 'Person Cell' reuse identifier");
    
    cell.lastNameLabel.text  = person.lastName;
    cell.firstNameLabel.text = person.fullFirstName;
    
    return cell;
}

@end
