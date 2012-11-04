//
//  CGKCountryTableViewController.m
//  Cegeka Registration
//
//  Created by Jan Sabbe on 4/11/12.
//
//

#import "CGKCountryTableViewController.h"

@interface CGKCountryTableViewController ()
@property NSArray* sectionsOfCountries;
@end

@implementation CGKCountryTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sectionsOfCountries = [self allCountriesDividedInSectionsByFirstLetter];
}


#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sectionsOfCountries objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"countryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString* country = [[self.sectionsOfCountries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = country;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* country = [[self.sectionsOfCountries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.countrySelectionDelegate countryController:self didSelectCountry:country];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Dividing countries in sections according to their first letter

- (NSArray*) setupEmptyArrayPerLetter {
    NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
	for (NSUInteger index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
	}
    return newSectionsArray;
}

- (NSArray*) sortedArrayOfCountries {
    NSMutableArray* countries = [NSMutableArray arrayWithCapacity:[[NSLocale ISOCountryCodes] count]];
    NSLocale* englishLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    for (NSString* isoCode in [NSLocale ISOCountryCodes]) {
        NSString* country = [englishLocale displayNameForKey:NSLocaleCountryCode value:isoCode];
        [countries addObject:country];
    }
    [countries sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return countries;
}

- (NSArray*) allCountriesDividedInSectionsByFirstLetter {
    NSArray *sections = [self setupEmptyArrayPerLetter];
    NSArray *countries = [self sortedArrayOfCountries];
    
    for (NSString* country in countries) {
        NSInteger indexOfSection = [[UILocalizedIndexedCollation currentCollation] sectionForObject:country collationStringSelector:@selector(uppercaseString)];
        [[sections objectAtIndex:indexOfSection] addObject:country];
    }
    return sections;
}

@end
