package SWF::Analysis::Tags;

use warnings;
use strict;

use SWF::Analysis::Reader;

use constant TAG_NAME => {
    0  => 'End',
    1  => 'ShowFrame',
    2  => 'DefineShape',
    3  => 'FreeCharacter',
    4  => 'PlaceObject',
    5  => 'RemoveObject',
    6  => 'DefineBitsJPEG',
    7  => 'DefineButton',
    8  => 'JPEGTables',
    9  => 'SetBackgroundColor',
    10 => 'DefineFont',
    11 => 'DefineText',
    12 => 'DoAction',
    13 => 'DefineFontInfo',
    14 => 'DefineSound',
    15 => 'StartSound',
    15 => 'StopSound',
    17 => 'DefineButtonSound',
    18 => 'SoundStreamHead',
    19 => 'SoundStreamBlock',
    20 => 'DefineBitsLossless',
    21 => 'DefineBitsJPEG2',
    22 => 'DefineShape2',
    23 => 'DefineButtonCxform',
    24 => 'Protect',
    25 => 'PathsArePostscript',
    26 => 'PlaceObject2',
    28 => 'RemoveObject2',
    29 => 'SyncFrame',
    31 => 'FreeAll',
    32 => 'DefineShape3',
    33 => 'DefineText2',
    34 => 'DefineButton2',
    35 => 'DefineBitsJPEG3',
    36 => 'DefineBitsLossless2',
    37 => 'DefineEditText',
    38 => 'DefineVideo',
    39 => 'DefineSprite',
    40 => 'NameCharacter',
    41 => 'ProductInfo',
    42 => 'DefineTextFormat',
    43 => 'FrameLabel',
    45 => 'SoundStreamHead2',
    46 => 'DefineMorphShape',
    47 => 'GenerateFrame',
    48 => 'DefineFont2',
    49 => 'GeneratorCommand',
    50 => 'DefineCommandObject',
    51 => 'CharacterSet',
    52 => 'ExternalFont',
    56 => 'Export',
    57 => 'Import',
    58 => 'EnableDebugger',
    59 => 'DoInitAction',
    60 => 'DefineVideoStream',
    61 => 'VideoFrame',
    62 => 'DefineFontInfo2',
    63 => 'DebugID',
    64 => 'EnableDebugger2',
    65 => 'ScriptLimits',
    66 => 'SetTabIndex',
    69 => 'FileAttributes',
    70 => 'PlaceObject3',
    71 => 'Import2',
    72 => 'DoABCDefine',
    73 => 'DefineFontAlignZones',
    74 => 'CSMTextSettings',
    75 => 'DefineFont3',
    76 => 'SymbolClass',
    77 => 'Metadata',
    78 => 'DefineScalingGrid',
    82 => 'DoABC',
    83 => 'DefineShape4',
    84 => 'DefineMorphShape2',
    86 => 'DefineSceneAndFrameData',
    87 => 'DefineBinaryData',
    88 => 'DefineFontName',
    90 => 'DefineBitsJPEG4',
};

sub run {
    my $self   = shift;
    my $reader = shift;

    my @tags = ();

    while (1) {
        my $header = $reader->getUI16LE();
        my $type   = ( $header & 0xFFC0 ) >> 6;
        my $length = $header & 0x003F;
        if ( $length == 0x3F ) {
            $length = $reader->getUI32LE();
        }
        unless ($type) {
            push(
                @tags,
                {
                    Type   => $type,
                    Length => $length,
                    Name   => TAG_NAME->{$type},
                    Value   => undef,
                }
            );
            last;
        }
        else {
            my $body = $reader->getData($length);
            push(
                @tags,
                {
                    Type   => $type,
                    Length => $length,
                    Name   => TAG_NAME->{$type},
                    Value  => $body,
                }
            );
        }
    }
    return \@tags;
}

1;
