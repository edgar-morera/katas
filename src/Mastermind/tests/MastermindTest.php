<?php declare(strict_types=1);

namespace Mastermind\Tests;

use PHPUnit\Framework\TestCase;
use Mastermind\Mastermind;

final class MastermindTest extends TestCase
{
    public function testShouldExistsAnArrayWithTheValidCombination(): void
    {
        $valid_combination = [];

        $mastermind = new Mastermind($valid_combination);

        $this->assertIsArray($mastermind->getCombination());
    }

    public function testShouldReturnEmptyForCombinationWithAnyMatches(): void
    {
        $valid_combination = ['red','blue','green'];
        $full_invalid_combination = ['pink','white','grey'];

        $mastermind = new Mastermind($valid_combination);

        $this->assertEmpty($mastermind->check($full_invalid_combination));
    }

    public function testShouldReturnTheColorsMatchedNotTakeAccountTheCorrectPosition(): void
    {
        $valid_combination = ['red', 'blue', 'green', 'pink'];
        $full_invalid_combination = ['green', 'white', 'red', 'grey'];
        $expected = [
            'valid_colors_not_correct_position' => ['green','red']
        ];

        $mastermind = new Mastermind($valid_combination);

        $this->assertEqualsCanonicalizing($expected, $mastermind->check($full_invalid_combination));
    }

    public function testShouldReturnTheColorsMatchedTakeAccountTheCorrectPosition(): void
    {
        $valid_combination = ['red', 'blue', 'green', 'grey'];
        $full_invalid_combination = ['red', 'white', 'black', 'grey'];
        $expected = [
            'matched_colors' => ['red','grey']
        ];

        $mastermind = new Mastermind($valid_combination);

        $this->assertEquals($expected, $mastermind->check($full_invalid_combination));
    }

    public function testShouldReturnTheColorsMatchedTakeAccountTheCorrectPositionAndNotTakeAccountTheCorrectPosition(): void
    {
        $valid_combination = ['red', 'blue', 'green', 'grey'];
        $full_invalid_combination = ['red', 'white', 'blue', 'grey'];
        $expected = [
            'matched_colors' => ['red','grey'],
            'valid_colors_not_correct_position' => ['blue']
        ];

        $mastermind = new Mastermind($valid_combination);

        $this->assertEquals($expected, $mastermind->check($full_invalid_combination));
    }

    public function testShouldReturnTrueForACorrectCombination(): void
    {
        $valid_combination = ['red', 'blue', 'green', 'grey'];
        
        $mastermind = new Mastermind($valid_combination);

        $this->assertTrue($mastermind->check($valid_combination));
    }

}