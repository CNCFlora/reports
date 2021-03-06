<?php
namespace cncflora\reports;

class Actions {

  public $title = "Ações";
  public $description = "Lista de ações de conservação necessárias ou em andamento.";
  public $is_private = true;
  public $fields = ["familia","nome científico","ação de conservação","situação",'detalhes','referencias'];
  public $filters=["checklist","family"];

  function run($dest,$checklist,$family=null) {
    fputcsv($dest,$this->fields, "\t");

    $repo=new \cncflora\repository\Profiles($checklist);

    if($family!=null) {
      $profiles=$repo->listFamily($family);
    } else {
      $profiles=$repo->listAll();
    }

    foreach($profiles as $d) {
      if(isset($d["actions"]) && is_array($d["actions"])) {
        foreach($d["actions"] as $t) {
          if(isset($t["action"])) {
              if (!array_key_exists("situation", $t)){
                  $t["situation"] = "";
              }
              if (!array_key_exists("details", $t)){
                  $t["details"] = "";
              }
              if (!array_key_exists("references", $t)){
                  $t["references"] = array();
              }
              $data=[
                $d["taxon"]["family"]
                ,$d["taxon"]["scientificNameWithoutAuthorship"]
                ,$t["action"]
                ,$t["situation"]
                ,$t["details"]
                ,implode(";",$t["references"])
              ];
              fputcsv($dest,$data, "\t");
          }
        }
      }
    }
  }
}
