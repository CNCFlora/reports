<?php

include 'base.php';

$fields = ["family","scientificName","action","situation",'details','references'];
fputcsv($csv,$fields);

foreach($all->rows as $row) {
  $d = $row->doc;
  if($d->metadata->type=='profile') {
    if(isset($d->actions) && is_array($d->actions)) {
      foreach($d->actions as $t) {
        if(isset($t->action)) {
          $data=[
            $d->taxon->family
            ,$d->taxon->scientificNameWithoutAuthorship
            ,$t->action
            ,$t->situation
            ,$t->details
            ,implode(";",$t->references)
          ];
          fputcsv($csv,$data);
        }
      }
    }
  }
}

