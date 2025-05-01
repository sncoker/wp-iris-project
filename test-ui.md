# IRIS Unit Testing Dashboard Documentation

A web application for managing and monitoring unit tests in IRIS.

## First-Time Use

When you first access the IRIS Unit Testing Dashboard, please note:

1. **Initial State**
   - The dashboard starts with no test data as tests haven't been run yet on IRIS
   - You'll need to either:
     - Run tests to see actual data
     - Enable sample data to see example results

2. **Viewing Sample Data**
   - Click the "Settings" button in the top-right corner
   - Enable the "Use sample data instead of API" toggle
   - Sample data will immediately appear in the dashboard

3. **Running Tests**
   - Since Production is already running on IRIS, you can run the sample tests immediately
   - Click the "Run All Tests in Project" button at the top of the dashboard
   - Tests will execute asynchronously
   - Results will appear during subsequent data refreshes

4. **Adjusting Refresh Time**
   - Open Settings
   - Find "Data Refresh Interval"
   - Select your preferred interval (2, 5, 10, or 30 minutes)
   - The dashboard will automatically update at this interval

5. **Troubleshooting**
   - If no results appear after running tests:
     - Verify the IRIS container is running
     - Check Settings for correct API URLs
     - Try enabling "Use sample data on API failure" as a fallback
     - Use the manual refresh button next to "Last updated"

## Settings Configuration

The dashboard includes a comprehensive settings panel that can be accessed by clicking the "Settings" button in the top-right corner. Here's how to configure each setting:

### API URLs

#### Test Results API URL
- Enter the URL endpoint that provides test results data
- Default: `http://localhost:62773/csp/unittest/service/results`
- Must be a valid URL
- Disabled when using sample data

#### Run All Tests URL
- Enter the URL endpoint for triggering test execution
- Default: `http://localhost:62773/csp/unittest/service/runtest`
- Must be a valid URL
- Disabled when using sample data

### Data Refresh Settings

#### Data Refresh Interval
- Choose how often the dashboard should fetch new data
- Options:
  - 2 minutes
  - 5 minutes
  - 10 minutes
  - 30 minutes
- Disabled when auto-refresh is turned off

#### Auto-Refresh Control
- Toggle to enable/disable automatic data refreshing
- When disabled:
  - Data refresh interval becomes inactive
  - Manual refresh still available via refresh button
  - "Auto-refresh disabled" message shown in UI

### Data Source Options

#### Use Sample Data
- Toggle to switch between API and sample data
- When enabled:
  - API URLs become disabled
  - Uses built-in sample data for testing
  - Helpful for development and testing

#### Use Sample Data on API Failure
- Toggle to control fallback behavior
- When enabled:
  - Automatically switches to sample data if API calls fail
  - Prevents empty dashboard state
  - Useful for development and testing

### Sample Data Management

#### Sample Data Field
- JSON editor for modifying sample test data
- Features:
  - Reset button to restore default data
  - Live preview of changes
- Useful for testing different data scenarios

## Viewing Your Test Results

The dashboard provides a hierarchical view of your test results, from unit test classes down to individual test cases.

### Unit Test Classes Overview

The main table displays all unit test classes with the following information:
- Unit Test Class name (with copy option for full class path)
- Number of unit tests in the class
- Visual status indicators showing passed, failed, and pending tests
- Actions including "View Details" to see individual test cases

### Detailed Test Cases View

Click "View Details" on any unit test class to see:
1. Test case status (Passed, Failed, or Pending)
2. Test case name
3. Description (if available)
4. Duration in milliseconds
5. Counter value
6. Action performed
7. Date and time of execution

#### Filtering Test Cases

Use the filter buttons above the test cases table to:
- Show all test cases
- Show only passed tests
- Show only failed tests
- Show only tests with descriptions

#### Sorting Options

Click column headers to sort by:
- Test Case Name (alphabetically)
- Date/Time (chronologically)

### Detailed Test Information

For a comprehensive view of any test case:
1. Click the "View All Data" button in the test case row
2. A popup will display all available information including:
   - Full status with visual indicator
   - Complete test case name
   - Full description
   - Precise duration
   - Counter value
   - Complete location (with copy option)
   - Action details
   - Formatted date and time

## Best Practices

1. **API Configuration**
   - Ensure API URLs are correct and accessible
   - Test connectivity before saving changes
   - Use HTTPS when possible for security

2. **Refresh Settings**
   - Choose refresh interval based on test frequency
   - Consider disabling auto-refresh for development
   - Use manual refresh when needed

3. **Sample Data**
   - Keep sample data representative of real data
   - Test with various data scenarios
   - Reset to defaults if issues occur