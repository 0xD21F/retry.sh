## retry.sh

A small bash script that automates retrying of commands an arbitrary number of times until success. The original intent was to use as a wrapper for a cron job that relies on external factors in order to succeed - wrapping it in this script allows it to retry if failure occurs.

## Example

>/usr/lib/retry.sh -s "php example.php" -r 15
