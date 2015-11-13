<?php

global $title, $description, $is_private, $fields;
$title = "Referências";
$description = "Lista com todas as referências utilizadas no recorte, separadas por espécie e indicação de onde são utilizadas.";
$is_private = false;
//$fields = ["family","scientificName","document","field","reference"];
// Field translation
$fields = ["familia","nome científico","tipo de documento", "campo no documento", "referências"];
include 'base.php';

fputcsv($csv,$fields);

foreach($all->rows as $row) {
  $d = $row->doc;
  if($d->metadata->type=='assessment') {
    if(isset($d->references) && is_array($d->references)) {
      foreach($d->references as $r) {
        if(is_string($r) && strlen(trim($r)) >= 2) {
            $data = [$d->taxon->family,$d->taxon->scientificNameWithoutAuthorship,"avaliação","",$r];
          fputcsv($csv,$data);
        }
      }
    }
  }else if($d->metadata->type=='profile') {
    foreach($d as $field=>$value) {
      if(is_object($value)) {
        if(isset($value->references) && is_array($value->references)) {
          foreach($value->references as $r) {
            if(is_string($r) && strlen(trim($r)) >= 2) {
                $data = [$d->taxon->family,$d->taxon->scientificNameWithoutAuthorship,"perfil de espécie",$field,$r];
              fputcsv($csv,$data);
            }
          }
        }
      } else if(is_Array($value)) {
        foreach($value as $value2) {
          if(is_object($value2)) {
            if(isset($value2->references) && is_array($value2->references)) {
              foreach($value2->references as $r) {
                if(is_string($r) && strlen(trim($r)) >= 2) {
                  $data = [$d->taxon->family,$d->taxon->scientificNameWithoutAuthorship,"profile",$field,$r];
                  fputcsv($csv,$data);
                }
              }
            }
          }
        }
      }
    }
  }
}

