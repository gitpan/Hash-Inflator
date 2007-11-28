use inc::Module::Install;
include 'Module::AutoInstall';

name 'Hash-Inflator';
all_from 'lib/Hash/Inflator.pm';
perl_version '5.006';

requires 'Class::Accessor::Complex';

build_requires 'Test::Differences';
build_requires 'Test::More' => '0.70';

process_templates(
    first_year => 2007,
    rest_from  => "$ENV{HOME}/.mitlib/standard_pod",
    start_tag  => '{%',
    end_tag    => '%}',
    other_authors => [
        'Rick Measham, C<< <rickm@cpan.org> >>',
    ],
);

use_standard_tests(without => 'pod_coverage');
auto_install;
auto_include;
WriteAll;
