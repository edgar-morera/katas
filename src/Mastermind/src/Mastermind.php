<?php

declare(strict_types=1);

namespace Mastermind;

class Mastermind {

    public function __construct(private array $combination)
    {        
    }

    public function getCombination(): array
    {
        return $this->combination;
    }

    public function check($input_combination): bool|array
    {
        if ($input_combination === $this->combination) {
            return true;
        }
        
        $result = [];

        foreach ($input_combination as $pos=>$color) {
            if (in_array($color, $this->combination)) {

                if ($pos == array_search($color, $this->combination)) {
                    $result['matched_colors'][] = $color;    
                } else {
                    $result['valid_colors_not_correct_position'][] = $color;
                }
                
            }
        }

        return $result;
    }
}